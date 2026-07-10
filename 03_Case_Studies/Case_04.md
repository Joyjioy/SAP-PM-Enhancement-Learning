# Case 04 - Validate Permit Before Creating Notification

## Business Requirement

Program saat ini akan membuat Notification secara otomatis apabila Equipment memenuhi seluruh business rule.

Departemen HSE mengusulkan penambahan validasi.

Sebelum Notification dibuat, sistem harus memastikan bahwa Equipment memiliki Permit dengan status **APPROVED**.

Apabila Permit belum tersedia, masih berstatus **PENDING**, atau sudah **EXPIRED**, proses pembuatan Notification harus dibatalkan dan pengguna diberikan pesan kesalahan.

---

## Existing System

Program saat ini menggunakan business rule berikut.

```text
Equipment TRIP

↓

Running Hour > 6000

↓

Belum Ada Notification Aktif

↓

Create Notification
```

Status Permit belum menjadi bagian dari proses validasi.

---

## Problem Analysis

Equipment dapat memenuhi seluruh syarat maintenance, tetapi pekerjaan tidak boleh dilakukan apabila Permit belum disetujui.

Karena itu diperlukan validasi tambahan sebelum Notification dibuat.

---

## Business Logic

Untuk setiap Equipment.

1. Periksa apakah Status = **TRIP**.
2. Periksa Running Hour.
3. Cari Notification aktif.
4. Cari Permit berdasarkan Equipment.
5. Jika Permit = **APPROVED**, buat Notification.
6. Jika Permit = **NONE**, **PENDING**, atau **EXPIRED**, batalkan proses dan tampilkan pesan kesalahan.

---

## Data Required

| File | Kegunaan |
|------|----------|
| equipment.csv | Status dan Running Hour |
| notification.csv | Notification aktif |
| permit.csv | Status Permit |

### equipment.csv

- EQUNR
- STATUS
- RUNNING_HOUR

### notification.csv

- EQUNR
- STATUS

### permit.csv

- EQUNR
- PERMIT_STATUS

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

↓

Running Hour > 6000 ?

↓

Notification Aktif Ada?

├── Ya
│
└── Next Equipment
│
▼

Cari Permit

↓

Permit APPROVED ?

├── Tidak
│
│ MESSAGE Error
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

Running Hour > 6000

↓

Search Active Notification

↓

Notification Found ?

↓

No

↓

Read Permit

↓

Permit APPROVED ?

↓

Yes

↓

Create Notification
```

---

## Expected Result

Berdasarkan Mock Database.

Equipment berikut memenuhi seluruh business rule dan memiliki Permit **APPROVED**.

| Equipment | Permit |
|-----------|--------|
| MTR003 | APPROVED |
| MTR008 | APPROVED |
| MTR015 | APPROVED |
| CMP002 | APPROVED |

Karena seluruh Equipment tersebut sudah memiliki Notification aktif, Notification baru tetap tidak dibuat.

Untuk menguji validasi Permit, tambahkan Equipment berikut.

```text
EQUNR          : MTR016
STATUS         : TRIP
RUNNING_HOUR   : 7200
Permit         : PENDING
Notification   : Tidak Ada
```

Expected output.

```text
Error : Permit is not approved.
```

---

## Notes

Case ini merupakan enhancement dari Case 03.

Perubahan yang ditambahkan adalah validasi Permit sebelum proses pembuatan Notification.

---

## Related ABAP Concepts

- READ TABLE
- IF
- MESSAGE
- EXIT