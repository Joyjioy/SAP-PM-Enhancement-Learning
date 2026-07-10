# Case 03 - Restrict Notification Creation Based on Running Hour

## Business Requirement

Program saat ini membuat Notification secara otomatis untuk Equipment yang mengalami **TRIP** dan belum memiliki Notification aktif.

Departemen Maintenance mengusulkan perubahan business rule.

Notification hanya boleh dibuat apabila Equipment telah beroperasi lebih dari **6000 jam**.

Equipment dengan Running Hour di bawah batas tersebut dianggap belum memerlukan tindakan maintenance sehingga sistem tidak perlu membuat Notification.

---

## Existing System

Program saat ini menggunakan logika berikut.

```text
Equipment TRIP

↓

Belum Ada Notification Aktif

↓

Create Notification
```

Running Hour belum menjadi bagian dari proses pengambilan keputusan.

---

## Problem Analysis

Program masih dapat membuat Notification pada Equipment yang baru beroperasi dalam waktu singkat.

Departemen Maintenance ingin memastikan bahwa Notification hanya dibuat apabila Equipment telah melewati batas Running Hour yang ditentukan.

Dengan demikian Notification yang dihasilkan lebih sesuai dengan kondisi operasi Equipment.

---

## Business Logic

Untuk setiap Equipment.

1. Periksa apakah Status = **TRIP**.
2. Periksa Running Hour.
3. Jika Running Hour ≤ 6000, hentikan proses.
4. Jika Running Hour > 6000, cari Notification aktif.
5. Jika belum terdapat Notification aktif, buat Notification baru.

---

## Data Required

| File | Kegunaan |
|------|----------|
| equipment.csv | Membaca status dan Running Hour |
| notification.csv | Memeriksa Notification aktif |

### equipment.csv

- EQUNR
- STATUS
- RUNNING_HOUR

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

Running Hour > 6000 ?

↓

Yes

↓

Search Active Notification

↓

Notification Found ?

↓

No

↓

Create Notification
```

---

## Expected Result

Berdasarkan Mock Database.

Equipment berikut memenuhi syarat Status = TRIP dan Running Hour > 6000.

| Equipment | Running Hour | Notification |
|-----------|-------------:|--------------|
| MTR003 | 6450 | N000002 (IN_PROCESS) |
| MTR008 | 7150 | N000005 (IN_PROCESS) |
| MTR015 | 8300 | N000008 (OPEN) |
| CMP002 | 9400 | N000014 (IN_PROCESS) |

Seluruh Equipment tersebut telah memiliki Notification aktif sehingga program tidak membuat Notification baru.

Untuk menguji business rule, tambahkan data berikut.

```text
EQUNR          : MTR016
STATUS         : TRIP
RUNNING_HOUR   : 7200
Notification   : Tidak Ada
```

Expected output.

```text
Create Notification : MTR016
```

---

## Notes

Case ini merupakan enhancement dari Case 02.

Perubahan yang ditambahkan adalah validasi Running Hour sebelum proses pemeriksaan Notification dilakukan.

---

## Related ABAP Concepts

- IF
- LOOP
- READ TABLE
- SY-SUBRC