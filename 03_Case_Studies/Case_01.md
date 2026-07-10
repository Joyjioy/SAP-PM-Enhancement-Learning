# Case 01 - Automatically Create Notification for Tripped Equipment

## Business Requirement

Operator melaporkan bahwa beberapa equipment mengalami kondisi **TRIP**.

Saat ini proses pembuatan Notification masih dilakukan secara manual oleh engineer. Hal tersebut menyebabkan kemungkinan keterlambatan pencatatan apabila engineer belum membuka SAP.

Untuk mempercepat proses maintenance, perusahaan ingin sistem secara otomatis membuat Notification apabila ditemukan Equipment dengan status **TRIP** dan belum memiliki Notification yang masih aktif.

---

## Existing System

Saat ini alur kerja yang berjalan adalah sebagai berikut.

```text
Equipment TRIP

↓

Operator Melapor

↓

Engineer Login SAP

↓

Create Notification

↓

Maintenance Dimulai
```

Proses tersebut sepenuhnya bergantung pada tindakan engineer.

---

## Problem Analysis

Proses manual memiliki beberapa kelemahan.

- Notification dapat terlambat dibuat.
- Engineer dapat lupa membuat Notification.
- Equipment yang sama berpotensi memiliki lebih dari satu Notification aktif apabila tidak dilakukan validasi.

Diperlukan logika tambahan agar SAP dapat membantu proses tersebut secara otomatis.

---

## Business Logic

Sistem melakukan pemeriksaan terhadap seluruh Equipment.

Untuk setiap Equipment.

1. Periksa apakah Status = **TRIP**.
2. Cari Notification berdasarkan Equipment.
3. Periksa apakah terdapat Notification dengan status **OPEN** atau **IN_PROCESS**.
4. Apabila belum terdapat Notification aktif, buat Notification baru.

---

## Data Required

Mock Database yang digunakan.

| File | Kegunaan |
|------|----------|
| equipment.csv | Membaca status Equipment |
| notification.csv | Memeriksa Notification aktif |

Field yang digunakan.

### equipment.csv

- EQUNR
- STATUS

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

Cari Notification Aktif

↓

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

Search Active Notification

↓

Notification Found ?

↓

Yes

↓

Continue Loop

↓

No

↓

Create Notification
```

---

## Expected Result

Berdasarkan Mock Database yang digunakan pada repository ini, seluruh Equipment dengan status **TRIP** sudah memiliki Notification aktif sehingga program **tidak membuat Notification baru**.

| Equipment | Notification Aktif |
|-----------|--------------------|
| MTR003 | N000002 (IN_PROCESS) |
| MTR008 | N000005 (IN_PROCESS) |
| MTR015 | N000008 (OPEN) |
| CMP002 | N000014 (IN_PROCESS) |

Agar business rule dapat diuji, tambahkan satu data Equipment baru dengan kondisi berikut.

```text
EQUNR  : MTR016
STATUS : TRIP
```

Tanpa menambahkan Notification untuk Equipment tersebut.

Expected output.

```text
Create Notification : MTR016
```

---

## Notes

Pada Mock Database saat ini tidak terdapat Equipment TRIP yang belum memiliki Notification aktif.

Oleh karena itu program tidak akan menghasilkan Notification baru hingga tersedia data yang memenuhi business rule.

---

## Related ABAP Concepts

- SELECT
- Internal Table
- LOOP
- READ TABLE
- IF
- SY-SUBRC