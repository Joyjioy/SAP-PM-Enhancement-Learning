# COMMIT WORK

## Latar Belakang

Pada SAP, perubahan data tidak selalu langsung disimpan ke database setelah suatu statement dijalankan.

Selama sebuah transaksi berlangsung, berbagai operasi seperti pembuatan Notification, perubahan Equipment, maupun pembuatan Work Order dapat dilakukan terlebih dahulu tanpa langsung mengubah database secara permanen.

Pendekatan ini memungkinkan SAP menjaga konsistensi data. Apabila salah satu proses gagal, seluruh perubahan dalam transaksi dapat dibatalkan sehingga database tetap berada pada kondisi yang valid.

Untuk mengakhiri transaksi dan menyimpan seluruh perubahan tersebut, ABAP menggunakan statement `COMMIT WORK`.

---

# Tujuan

`COMMIT WORK` digunakan untuk mengakhiri sebuah Logical Unit of Work (LUW) dan meminta SAP menyimpan seluruh perubahan yang telah berhasil diproses ke database.

---

# Logical Unit of Work (LUW)

Sebelum memahami `COMMIT WORK`, penting untuk memahami konsep **Logical Unit of Work (LUW)**.

LUW adalah sekumpulan proses yang dianggap sebagai satu transaksi bisnis.

Contoh.

```
Motor TRIP

↓

Create Notification

↓

Create Work Order

↓

Update Equipment Status

↓

Insert History

↓

COMMIT WORK
```

Keempat proses tersebut membentuk satu LUW.

SAP menganggap seluruh proses tersebut harus berhasil sebagai satu kesatuan.

---

# Mengapa SAP Menggunakan LUW?

Misalkan business process berikut.

```
Create Notification

↓

Create Work Order

↓

Update Equipment
```

Bayangkan Notification berhasil dibuat.

Namun ketika membuat Work Order terjadi kesalahan.

Apabila Notification sudah lebih dahulu disimpan ke database, maka sistem akan memiliki Notification tanpa Work Order.

Data menjadi tidak konsisten.

Dengan menggunakan LUW, SAP dapat menunggu hingga seluruh proses selesai sebelum perubahan benar-benar disimpan.

---

# Cara Kerja COMMIT WORK

Secara sederhana.

```text
Program

↓

Business Logic

↓

Perubahan berada pada SAP LUW

↓

COMMIT WORK

↓

Database diperbarui
```

Perubahan dianggap permanen setelah LUW berhasil di-commit.

---

# Sintaks Dasar

```abap
COMMIT WORK.
```

Statement ini tidak memiliki parameter.

---

# Contoh Kasus

Business Requirement.

> Ketika Motor mengalami TRIP, sistem harus:

- Membuat Notification.
- Membuat Work Order.
- Mengubah Status Equipment.

Implementasi.

```abap
CALL FUNCTION 'Z_CREATE_NOTIFICATION'.

CALL FUNCTION 'Z_CREATE_WORKORDER'.

CALL FUNCTION 'Z_UPDATE_EQUIPMENT'.

COMMIT WORK.
```

Urutan proses.

```text
Notification

↓

Work Order

↓

Equipment

↓

COMMIT WORK

↓

Semua perubahan disimpan
```

---

# Apa yang Terjadi Sebelum COMMIT?

Sebelum `COMMIT WORK`, program telah meminta SAP melakukan berbagai perubahan.

Namun perubahan tersebut masih berada dalam konteks transaksi yang sedang berjalan.

Secara konseptual.

```text
Database

↓

Belum berubah
```

Sedangkan SAP telah mengetahui perubahan apa saja yang harus dilakukan apabila transaksi berhasil diselesaikan.

Barulah setelah `COMMIT WORK`, perubahan tersebut menjadi permanen.

---

# COMMIT WORK dan ROLLBACK WORK

Apabila seluruh proses berhasil.

```abap
COMMIT WORK.
```

Apabila ditemukan kesalahan yang menyebabkan transaksi harus dibatalkan.

```abap
ROLLBACK WORK.
```

`ROLLBACK WORK` membatalkan seluruh perubahan yang masih berada dalam LUW.

---

# COMMIT WORK dan BAPI

Banyak BAPI digunakan untuk membuat atau mengubah data bisnis SAP.

Sebagian besar BAPI **tidak langsung menyimpan perubahan ke database**.

Sebagai contoh.

```abap
CALL FUNCTION 'BAPI_ALM_NOTIF_CREATE'.
```

Setelah BAPI selesai dijalankan, proses bisnis telah berhasil dilakukan, tetapi transaksi belum diakhiri.

Pada sebagian besar BAPI, transaksi diselesaikan menggunakan.

```abap
CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
```

Function Module tersebut pada akhirnya menjalankan mekanisme commit transaksi SAP sehingga perubahan menjadi permanen.

Karena itu, ketika menggunakan BAPI, dokumentasi resmi SAP perlu diperiksa untuk mengetahui mekanisme commit yang direkomendasikan.

---

# COMMIT WORK vs BAPI_TRANSACTION_COMMIT

Keduanya berhubungan dengan penyelesaian transaksi, tetapi digunakan pada konteks yang berbeda.

| COMMIT WORK | BAPI_TRANSACTION_COMMIT |
|--------------|-------------------------|
| Statement ABAP | Function Module SAP |
| Digunakan pada transaksi ABAP secara umum | Umumnya digunakan setelah pemanggilan BAPI |
| Mengakhiri LUW | Memastikan transaksi BAPI diselesaikan sesuai mekanisme SAP |

Pada program yang menggunakan BAPI, dokumentasi SAP umumnya merekomendasikan penggunaan `BAPI_TRANSACTION_COMMIT`.

---

# Kapan COMMIT WORK Dilakukan?

Prinsip yang umum digunakan.

```
Validasi

↓

Business Process

↓

Tidak ada Error

↓

COMMIT WORK
```

Dengan kata lain, commit dilakukan setelah seluruh business rule telah terpenuhi dan seluruh proses berhasil dijalankan.

---

# Kesalahan yang Sering Terjadi

## Melakukan COMMIT Terlalu Awal

```abap
CALL FUNCTION 'Z_CREATE_NOTIFICATION'.

COMMIT WORK.

CALL FUNCTION 'Z_CREATE_WORKORDER'.
```

Apabila pembuatan Work Order gagal, Notification sudah terlanjur tersimpan.

Business process menjadi tidak lengkap.

---

## Tidak Melakukan Commit

Program berhasil menjalankan seluruh proses, tetapi transaksi tidak pernah diakhiri.

Akibatnya perubahan dapat tidak tersimpan ke database.

---

## Menggunakan COMMIT WORK Setelah BAPI Tanpa Memeriksa Dokumentasi

Tidak semua BAPI memiliki mekanisme transaksi yang sama.

Sebelum menentukan cara melakukan commit, periksa dokumentasi resmi BAPI yang digunakan.

---

# Ringkasan

- `COMMIT WORK` mengakhiri Logical Unit of Work (LUW).
- LUW merupakan sekumpulan proses yang dianggap sebagai satu transaksi bisnis.
- Perubahan baru menjadi permanen setelah transaksi berhasil di-commit.
- `ROLLBACK WORK` digunakan untuk membatalkan seluruh perubahan dalam LUW.
- Pada penggunaan BAPI, mekanisme commit yang direkomendasikan umumnya adalah `BAPI_TRANSACTION_COMMIT`.
- Commit sebaiknya dilakukan setelah seluruh business rule dan proses bisnis berhasil diselesaikan.