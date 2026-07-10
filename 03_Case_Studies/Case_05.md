# Case 05 - Automatically Create Work Order from Approved Notification

## Business Requirement

Program saat ini berhasil membuat Notification secara otomatis setelah seluruh business rule terpenuhi.

Departemen Maintenance mengusulkan enhancement berikutnya.

Apabila Notification telah berhasil dibuat, sistem juga harus membuat Work Order secara otomatis sehingga planner tidak perlu membuatnya secara manual.

Work Order hanya boleh dibuat apabila Notification masih berstatus **OPEN** atau **IN_PROCESS** dan belum memiliki Work Order.

---

## Existing System

Program saat ini menggunakan alur berikut.

```text
Equipment

↓

Notification

↓

Finish
```

Planner masih membuat Work Order secara manual melalui SAP.

---

## Problem Analysis

Proses pembuatan Work Order masih bergantung pada planner.

Akibatnya terdapat jeda waktu antara Notification dibuat dengan Work Order diterbitkan.

Business rule baru diperlukan agar Work Order dapat dibuat secara otomatis setelah Notification memenuhi syarat.

---

## Business Logic

Untuk setiap Notification.

1. Periksa apakah Status = **OPEN** atau **IN_PROCESS**.
2. Cari Work Order berdasarkan Notification.
3. Jika Work Order sudah ada, lanjutkan ke Notification berikutnya.
4. Jika Work Order belum ada, buat Work Order baru.

---

## Data Required

| File | Kegunaan |
|------|----------|
| notification.csv | Membaca Notification aktif |
| workorder.csv | Memeriksa Work Order |

### notification.csv

- NOTIF_NO
- STATUS

### workorder.csv

- NOTIF_NO

---

## Flowchart

```text
Start

↓

Read Notification

↓

Loop Notification

↓

Status Active ?

├── No
│
└── Next Notification
│
▼

Cari Work Order

↓

Work Order Ditemukan?

├── Ya
│
└── Next Notification
│
▼

Create Work Order

↓

Next Notification

↓

End
```

---

## Pseudo Code

```text
Read Notification

↓

Loop Notification

↓

Status Active ?

↓

Search Work Order

↓

Work Order Found ?

↓

Yes

↓

Continue Loop

↓

No

↓

Create Work Order
```

---

## Expected Result

Berdasarkan Mock Database saat ini, seluruh Notification yang masih aktif telah memiliki Work Order.

| Notification | Work Order |
|-------------|-----------|
| N000002 | WO000001 |
| N000005 | WO000002 |
| N000007 | WO000003 |
| N000008 | WO000004 |
| N000010 | WO000005 |
| N000012 | WO000006 |
| N000013 | WO000007 |
| N000014 | WO000008 |
| N000016 | WO000009 |

Program tidak akan membuat Work Order baru.

Untuk menguji business rule, tambahkan Notification berikut.

```text
NOTIF_NO : N000017
STATUS   : OPEN
```

Tanpa menambahkan data pada `workorder.csv`.

Expected output.

```text
Create Work Order : N000017
```

---

## Notes

Case ini merupakan enhancement setelah proses pembuatan Notification selesai.

Program tidak lagi memeriksa Equipment maupun Permit karena seluruh validasi tersebut telah dilakukan pada Case sebelumnya.

---

## Related ABAP Concepts

- READ TABLE
- PERFORM
- CALL FUNCTION