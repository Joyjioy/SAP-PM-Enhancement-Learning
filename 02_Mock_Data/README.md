# Mock Data

## Tujuan

Folder ini berisi dataset yang digunakan sebagai database simulasi untuk seluruh latihan ABAP pada repository ini.

Dataset disusun agar menyerupai lingkungan SAP Plant Maintenance (PM) dalam skala sederhana sehingga setiap case study dapat menggunakan data yang konsisten tanpa memerlukan sistem SAP yang sebenarnya.

Seluruh file pada folder ini saling berhubungan melalui key tertentu, terutama `EQUNR` (Equipment Number).

---

# Struktur Folder

```
02_Mock_Data/

├── master/
│   ├── employee.csv
│   ├── equipment.csv
│   └── functional_location.csv
│
├── transaction/
│   ├── permit.csv
│   ├── notification.csv
│   ├── workorder.csv
│   └── history.csv
│
└── schema.md
```

---

# Master Data

Master Data merupakan data yang relatif tetap dan menjadi referensi bagi tabel lainnya.

| File | Deskripsi |
|------|-----------|
| employee.csv | Data personel yang terlibat dalam proses maintenance. |
| equipment.csv | Data seluruh equipment pada plant. |
| functional_location.csv | Lokasi fisik setiap equipment. |

---

# Transaction Data

Transaction Data merupakan data yang berubah seiring aktivitas maintenance.

| File | Deskripsi |
|------|-----------|
| permit.csv | Status permit setiap equipment. |
| notification.csv | Data notification maintenance. |
| workorder.csv | Data work order yang berasal dari notification. |
| history.csv | Riwayat aktivitas setiap equipment. |

---

# Prinsip Desain

- Dataset dibuat untuk keperluan belajar ABAP.
- Struktur dibuat sederhana namun tetap mempertahankan relasi antar tabel.
- Seluruh case study menggunakan dataset yang sama.
- Data bersifat fiktif dan tidak merepresentasikan perusahaan tertentu.

---

# Primary Key

| File | Primary Key |
|------|-------------|
| employee.csv | USERID |
| equipment.csv | EQUNR |
| functional_location.csv | FUNC_LOC |
| permit.csv | EQUNR |
| notification.csv | NOTIF_NO |
| workorder.csv | WO_NO |
| history.csv | EVENT_ID |

---

# Foreign Key

| Field | Mengacu ke |
|--------|------------|
| EQUNR | equipment.csv |
| FUNC_LOC | functional_location.csv |
| USERID | employee.csv |
| CREATED_BY | employee.csv |
| APPROVED_BY | employee.csv |
| PLANNER | employee.csv |
| TECHNICIAN | employee.csv |
| NOTIF_NO | notification.csv |