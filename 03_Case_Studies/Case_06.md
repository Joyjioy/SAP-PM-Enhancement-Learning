# Case 06 - Final Enhancement of Notification Creation Program

## Business Requirement

Program Notification telah mengalami beberapa enhancement.

Business rule yang berlaku saat ini merupakan hasil penggabungan seluruh perubahan yang telah disetujui oleh Departemen Maintenance dan HSE.

Notification hanya boleh dibuat apabila seluruh kondisi berikut terpenuhi.

- Equipment berstatus **TRIP**.
- Running Hour lebih dari **6000 jam**.
- Permit berstatus **APPROVED**.
- Belum terdapat Notification dengan status **OPEN** atau **IN_PROCESS**.

Program harus melakukan seluruh validasi tersebut sebelum membuat Notification baru.

---

## Existing System

Business rule berkembang secara bertahap.

| Case | Enhancement |
|------|-------------|
| Case 01 | Create Notification |
| Case 02 | Prevent Duplicate Notification |
| Case 03 | Running Hour Validation |
| Case 04 | Permit Validation |

Case ini menggabungkan seluruh enhancement tersebut menjadi satu business process.

---

## Problem Analysis

Apabila salah satu validasi diabaikan, sistem dapat menghasilkan Notification yang tidak sesuai dengan kondisi lapangan.

Contohnya.

- Equipment belum mencapai Running Hour minimum.
- Permit belum disetujui.
- Notification aktif sudah ada.

Karena itu seluruh business rule harus dijalankan sebagai satu rangkaian proses.

---

## Business Logic

Untuk setiap Equipment.

1. Periksa apakah Status = **TRIP**.
2. Periksa apakah Running Hour > **6000**.
3. Cari Permit berdasarkan Equipment.
4. Pastikan Permit berstatus **APPROVED**.
5. Cari Notification berdasarkan Equipment.
6. Pastikan belum terdapat Notification dengan status **OPEN** atau **IN_PROCESS**.
7. Jika seluruh kondisi terpenuhi, buat Notification baru.

---

## Data Required

| File | Kegunaan |
|------|----------|
| equipment.csv | Status dan Running Hour |
| permit.csv | Validasi Permit |
| notification.csv | Validasi Notification |

### equipment.csv

- EQUNR
- STATUS
- RUNNING_HOUR

### permit.csv

- EQUNR
- PERMIT_STATUS

### notification.csv

- EQUNR
- STATUS

---

## Flowchart

```text
Start

↓

Read Equipment

↓

Loop Equipment

↓

Status = TRIP ?

├── No
│
└── Next Equipment
│
▼

Running Hour > 6000 ?

├── No
│
└── Next Equipment
│
▼

Permit APPROVED ?

├── No
│
└── Next Equipment
│
▼

Notification Aktif Ditemukan?

├── Ya
│
└── Next Equipment
│
▼

Create Notification

↓

Next Equipment

↓

End
```

---

## Pseudo Code

```text
Read Equipment

↓

Loop Equipment

↓

IF Status = TRIP

↓

IF Running Hour > 6000

↓

Read Permit

↓

Permit APPROVED ?

↓

Read Notification

↓

Notification Found ?

↓

No

↓

Create Notification
```

---

## Expected Result

Berdasarkan Mock Database saat ini.

Equipment berikut memenuhi syarat:

| Equipment | Status | Running Hour | Permit | Notification |
|-----------|--------|-------------:|--------|--------------|
| MTR003 | TRIP | 6450 | APPROVED | IN_PROCESS |
| MTR008 | TRIP | 7150 | APPROVED | IN_PROCESS |
| MTR015 | TRIP | 8300 | APPROVED | OPEN |
| CMP002 | TRIP | 9400 | APPROVED | IN_PROCESS |

Seluruh Equipment tersebut telah memiliki Notification aktif sehingga program tidak membuat Notification baru.

Untuk menguji keseluruhan business rule, tambahkan data berikut.

```text
EQUNR          : MTR016
STATUS         : TRIP
RUNNING_HOUR   : 7200
PERMIT         : APPROVED
Notification   : Tidak Ada
```

Expected output.

```text
Create Notification : MTR016
```

---

## Notes

Case ini merupakan implementasi akhir dari seluruh enhancement yang telah dibuat pada Case 01 sampai Case 04.

Seluruh business rule dijalankan secara berurutan sehingga hanya Equipment yang memenuhi seluruh persyaratan yang dapat menghasilkan Notification baru.

---

## Related ABAP Concepts

- SELECT
- LOOP
- READ TABLE
- IF
- MESSAGE
- SY-SUBRC
- PERFORM