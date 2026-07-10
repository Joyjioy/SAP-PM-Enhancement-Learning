# Case 02 - Prevent Duplicate Notification

## Business Requirement

Perusahaan ingin memastikan bahwa setiap Equipment hanya memiliki satu Notification yang masih aktif untuk satu jenis permasalahan.

Apabila Equipment sudah memiliki Notification dengan status **OPEN** atau **IN_PROCESS**, sistem tidak boleh membuat Notification baru.

Dengan demikian engineer akan bekerja pada Notification yang sudah ada, bukan membuat Notification tambahan untuk Equipment yang sama.

---

## Existing System

Program saat ini sudah mampu membuat Notification secara otomatis ketika menemukan Equipment dengan status **TRIP**.

Namun program belum melakukan validasi apakah Equipment tersebut sudah memiliki Notification yang masih aktif.

Akibatnya Equipment yang sama berpotensi memiliki lebih dari satu Notification untuk permasalahan yang sama.

---

## Problem Analysis

Duplicate Notification dapat menyebabkan beberapa masalah.

- Engineer menerima pekerjaan yang sama lebih dari satu kali.
- Riwayat maintenance menjadi sulit ditelusuri.
- Satu Equipment dapat memiliki beberapa Work Order yang berasal dari Notification yang sama.

Sebelum membuat Notification baru, sistem harus memastikan bahwa Equipment belum memiliki Notification aktif.

---

## Business Logic

Untuk setiap Equipment dengan status **TRIP**.

1. Cari Notification berdasarkan EQUNR.
2. Periksa Status Notification.
3. Jika ditemukan Notification dengan status **OPEN** atau **IN_PROCESS**, hentikan proses.
4. Jika tidak ditemukan Notification aktif, buat Notification baru.

---

## Data Required

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
│  Skip
│
└──────────────┐
               │

Tidak          │

↓

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

Skip

↓

No

↓

Create Notification
```

---

## Expected Result

Berdasarkan Mock Database saat ini, seluruh Equipment dengan status **TRIP** telah memiliki Notification aktif sehingga program tidak membuat Notification baru.

| Equipment | Notification Aktif |
|-----------|--------------------|
| MTR003 | N000002 (IN_PROCESS) |
| MTR008 | N000005 (IN_PROCESS) |
| MTR015 | N000008 (OPEN) |
| CMP002 | N000014 (IN_PROCESS) |

Untuk menguji enhancement ini, tambahkan satu Equipment baru dengan kondisi berikut.

```text
EQUNR  : MTR016
STATUS : TRIP
```

Tanpa Notification aktif.

Expected output.

```text
Create Notification : MTR016
```

---

## Notes

Case ini merupakan enhancement dari Case 01.

Perubahan yang dilakukan adalah menambahkan validasi agar Notification baru hanya dibuat apabila Equipment belum memiliki Notification aktif.

---

## Related ABAP Concepts

- READ TABLE
- WITH KEY
- SY-SUBRC
- IF
- LOOP