import asyncio
import cv2
import websockets
import base64
import numpy as np
import urllib.request
import pandas as pd
import datetime
import time
from collections import Counter
from ultralytics import YOLO
import easyocr
import csv
import firebase_admin
from firebase_admin import credentials, firestore
import requests
import os
import glob
import sys

# Inisialisasi Firebase
cred = credentials.Certificate("skripsi-ba-parkir-99-firebase-adminsdk-ex120-d2bdfcdc2c.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

# Konfigurasi Firebase
mitra_uid = None

reader = easyocr.Reader(['en'], gpu=False)

# Check if UID is provided as a command line argument
if len(sys.argv) > 1:
    mitra_uid = sys.argv[1]
    print("Mitra UID:", mitra_uid)
else:
    print("Mitra UID not provided as an argument")

# Load model deteksi mobil
model_mobil = YOLO('python\models\mobil.pt')
model_plat = YOLO('python\models\plat.pt')

threshold = 0.5


def convert_license_plate_rules(license_plate_text):
    # Define conversion rules for the license plate parts
    conversion_dict_awal = {
        '0': 'O',
        '1': 'I',
        '2': 'Z',
        '3': 'B',
        '4': 'A',
        '5': 'S',
        '6': 'D',
        '7': 'N',
        # Add more rules as needed
    }

    conversion_dict_tengah = {
        'O': '0',
        'I': '1',
        'Z': '2',
        'B': '3',
        'A': '4',
        'S': '5',
        # Add more rules as needed
    }

    conversion_dict_akhir = {
        '0': 'O',
        '1': 'I',
        '2': 'Z',
        '3': 'B',
        '4': 'A',
        '5': 'S',
        '9' : 'S'
        # Add more rules as needed
    }

    # Remove spaces from the license plate text
    license_plate_text = license_plate_text.replace(" ", "")

    # Split the license plate text into parts (awal, tengah, akhir)
    awal, tengah, akhir = license_plate_text[:2], license_plate_text[2:-2], license_plate_text[-2:]

    # Apply conversion rules to each part
    converted_awal = ''.join(conversion_dict_awal.get(char, char) for char in awal)

    # Apply conversion rules to each part
    converted_tengah = ''.join(conversion_dict_tengah.get(char, char) for char in tengah)

    converted_akhir = ''.join(conversion_dict_akhir.get(char, char) for char in akhir)

    # Combine the converted parts
    converted_license_plate = f"{converted_awal} {converted_tengah} {converted_akhir}"

    return converted_license_plate



# Baca label
my_file = open("python\models\labels.txt", "r")
data = my_file.read()
class_list = data.split("\n")

# Inisialisasi area parkir
areas_data = db.collection("mitras").document(mitra_uid).collection("slot").stream()
areas = {}
area_filled_status = {}

for doc in areas_data:
    doc_data = doc.to_dict()
    area_name = doc_data["codeSlot"]
    area_position = doc_data["positionSlot"]

    x1y1 = {"dx": doc_data["x1y1"]["dx"], "dy": doc_data["x1y1"]["dy"]}
    x2y2 = {"dx": doc_data["x2y2"]["dx"], "dy": doc_data["x2y2"]["dy"]}
    x3y3 = {"dx": doc_data["x3y3"]["dx"], "dy": doc_data["x3y3"]["dy"]}
    x4y4 = {"dx": doc_data["x4y4"]["dx"], "dy": doc_data["x4y4"]["dy"]}

    area_coordinates = [
        (x1y1["dx"], x1y1["dy"]),
        (x2y2["dx"], x2y2["dy"]),
        (x3y3["dx"], x3y3["dy"]),
        (x4y4["dx"], x4y4["dy"]),
    ]

    areas[area_name] = {"coordinates": area_coordinates, "position": area_position, "detection_time": None}
    area_filled_status[area_name] = False

# URL kamera
url = 'http://192.168.193.1/capture'

# Set status awal semua jadi off
for area, config in areas.items():
    posisi = config["position"]
    doc_ref = db.collection("mitras").document(mitra_uid).collection("slot").document(posisi)
    doc_ref.update({"status": "off", "dateOn": "", "timeOn": ""})

area_image_counter = Counter()

csv_data = []

MAX_IMAGES_TO_CAPTURE = 10

# Fungsi deteksi dan kirim hasil
async def kirim_hasil_deteksi(websocket, path):
    while True:
        # Ambil frame dari kamera
        img_resp = urllib.request.urlopen(url)
        img_arr = np.array(bytearray(img_resp.read()), dtype=np.uint8)
        frame = cv2.imdecode(img_arr, -1)

        plat_crop_image_paths = []

        for area, config in areas.items():
            area_coordinates = np.array(config["coordinates"], np.int32)
            is_car_detected = False

            # Deteksi mobil
            results_mobil = model_mobil(frame)
            a_mobil = results_mobil[0].boxes.data
            px_mobil = pd.DataFrame(a_mobil).astype("float")


            for _, row_mobil in px_mobil.iterrows():
                x1_mobil, y1_mobil, x2_mobil, y2_mobil, _, d_mobil = map(int, row_mobil)
                c_mobil = class_list[d_mobil]

                if 'mobil' in c_mobil:
                    cx_mobil = (x1_mobil + x2_mobil) // 2
                    cy_mobil = (y1_mobil + y2_mobil) // 2

                    results1_mobil = cv2.pointPolygonTest(area_coordinates, ((cx_mobil, cy_mobil)), False)
                    if results1_mobil >= 0:
                        cv2.putText(frame, f"{area}", (x1_mobil, y1_mobil - 20), cv2.FONT_HERSHEY_COMPLEX, 0.5, (255, 255, 255), 1)
                        cv2.circle(frame, (cx_mobil, cy_mobil), 3, (0, 0, 255), -1)
                        cv2.putText(frame, str(c_mobil), (x1_mobil, y1_mobil), cv2.FONT_HERSHEY_COMPLEX, 0.5, (255, 255, 255), 1)

                        # Set status mobil terdeteksi di dalam area
                        is_car_detected = True

                        results_plat = model_plat(frame)[0]

                        ocr_counter = 0

                        for result_plat in results_plat.boxes.data.tolist():
                                    x1_plat, y1_plat, x2_plat, y2_plat, score_plat, class_id_plat = result_plat

                                    if score_plat > threshold:
                                        cx_plat = int(x1_plat + x2_plat) // 2
                                        cy_plat = int(y1_plat + y2_plat) // 2

                                        results2_plat = cv2.pointPolygonTest(area_coordinates, ((cx_plat, cy_plat)), False)
                                        if results2_plat >= 0:
                                            cv2.rectangle(frame, (int(x1_plat), int(y1_plat)), (int(x2_plat), int(y2_plat)),
                                                        (0, 255, 0), 4)
                                            cv2.putText(frame, results_plat.names[int(class_id_plat)].upper(),
                                                        (int(x1_plat), int(y1_plat - 10)),
                                                        cv2.FONT_HERSHEY_SIMPLEX, 1.3, (0, 255, 0), 3, cv2.LINE_AA)
                                            
                                            plat_crop = frame[int(y1_plat):int(y2_plat), int(x1_plat):int(x2_plat)]
                                    
                                            resize_factor = 3

                                            plat_crop_resized = cv2.resize(plat_crop, (0, 0), fx=resize_factor, fy=resize_factor)

                                            plat_crop_gray = cv2.cvtColor(plat_crop_resized, cv2.COLOR_BGR2GRAY)

                                            plat_crop_image_path = f'python/ocr/images/{area}_{area_image_counter[area] + 1}.png'
                                            area_image_counter[area] += 1

                                            if area_image_counter[area] <= MAX_IMAGES_TO_CAPTURE:

                                                lampu_url = 'http://192.168.193.1/control?var=led_intensity&val=100'
                                                requests.get(lampu_url)
                                                cv2.imwrite(plat_crop_image_path, plat_crop_gray)

                                                plat_crop_image_paths.append(plat_crop_image_path)

                                                # Pemanggilan fungsi OCR dengan resolusi tinggi
                                                ocr_results = reader.readtext(
                                                    plat_crop_image_path,
                                                    detail=0,
                                                    allowlist='ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
                                                )
                                            
                                                if ocr_results:
                                                    plat_nomor = ' '.join(ocr_results)  # Mengambil semua hasil OCR

                                                    converted_plate = convert_license_plate_rules(plat_nomor)

                                                    existing_entry_index = next(
                                                            (i for i, entry in enumerate(csv_data) if entry[1] == plat_crop_image_path),
                                                            None)
                                                    if existing_entry_index is not None:
                                                        csv_data[existing_entry_index][2] = plat_nomor
                                                    else:
                                                        csv_data.append([area, plat_crop_image_path, converted_plate])

                                                    ocr_counter += 1  # Increment the OCR counter
                                                    
                                                    if area_image_counter[area] == MAX_IMAGES_TO_CAPTURE:
                                                        lampu_url = 'http://192.168.193.1/control?var=led_intensity&val=0'
                                                        requests.get(lampu_url)

                        if ocr_counter > 0:
                            csv_file_path = 'python/ocr/hasil_ocr.csv'
                            with open(csv_file_path, mode='w', newline='') as file:
                                writer = csv.writer(file)
                                writer.writerow(['Area', 'Image Path', 'Plat Nomor'])
                                writer.writerows(csv_data)
                        else:
                            print("No OCR performed. CSV file not saved.")

                                # Load the CSV file into a DataFrame
                        df = pd.DataFrame(csv_data, columns=['Area', 'Image Path', 'Plat Nomor'])

                        plat_counter = df.groupby(['Area', 'Plat Nomor']).size().reset_index(name='Count')

                        for area in df['Area'].unique():
                            area_data = plat_counter[plat_counter['Area'] == area]
                            if not area_data.empty:
                                max_count_row = area_data.loc[area_data['Count'].idxmax()]

                                most_common_plate = max_count_row['Plat Nomor'].replace(" ", "")
                                frequency = max_count_row['Count']
                                total_data = len(df[df['Area'] == area])

                                if total_data >= MAX_IMAGES_TO_CAPTURE:
                                    plat_doc_name = area
                                    mitra_ref = db.collection("mitras").document(mitra_uid)
                                    slot_ref = mitra_ref.collection("slot").where("codeSlot", "==", area).stream()

                                    for doc in slot_ref:
                                        slot_doc_ref = doc.reference
                                        plat_data = {
                                        "plat": most_common_plate,
                                        }
                                        slot_doc_ref.update(plat_data)

                # Simpan waktu deteksi pertama kali jika belum tersimpan
                if config["detection_time"] is None:
                    config["detection_time"] = time.time()

            cv2.polylines(frame, [area_coordinates], True, (0, 255, 0), 2)

            # Cek apakah mobil ada di dalam area pada iterasi saat ini
            if is_car_detected:
                if not area_filled_status[area]:
                    # Cek apakah mobil berada di dalam area selama lebih dari 1 detik
                    current_time = time.time()
                    detection_time = config["detection_time"]
                    if current_time - detection_time > 10:
                        posisi = config["position"]
                        doc_ref = db.collection("mitras").document(mitra_uid).collection("slot").document(posisi)
                        dateOn = datetime.datetime.now().strftime("%Y-%m-%d")
                        timeOn = datetime.datetime.now().strftime("%H:%M:%S")
                        doc_ref.update({"status": "on", "dateOn": dateOn, "timeOn": timeOn})
                        print(f"{area.capitalize()} Terisi")

                        area_filled_status[area] = True
                        
            else:
                
                area_image_counter[area] = 0

                if area_filled_status[area]:
                    posisi = config["position"]
                    doc_ref = db.collection("mitras").document(mitra_uid).collection("slot").document(posisi)
                    doc_ref.update({"status": "off", "dateOn": "", "timeOn": ""})
                    print(f"{area.capitalize()} Kosong")
                    area_filled_status[area] = False

        # Encode frame dan kirim melalui WebSocket
        _, img_encoded = cv2.imencode('.jpg', frame)
        img_bytes = img_encoded.tobytes()
        await websocket.send(img_bytes)

# Mulai server WebSocket
start_server = websockets.serve(kirim_hasil_deteksi, "127.0.0.1", 8888)

# Jalankan event loop
asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()
