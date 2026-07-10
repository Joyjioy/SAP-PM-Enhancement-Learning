# Enhancement Framework

## Latar Belakang

SAP menyediakan ribuan transaksi standar yang digunakan untuk menjalankan proses bisnis perusahaan. Sebagian besar transaksi tersebut dikembangkan langsung oleh SAP dan tidak dirancang untuk dimodifikasi secara langsung oleh pengguna.

Sebagai contoh, perusahaan mungkin ingin menambahkan aturan baru pada proses pembuatan Notification.

Business Requirement.

```
Notification hanya boleh dibuat apabila Permit telah disetujui.
```

SAP standar belum tentu memiliki aturan tersebut.

Mengubah source code standar SAP secara langsung bukan merupakan pendekatan yang disarankan karena perubahan tersebut dapat hilang ketika sistem diperbarui (upgrade) atau menyebabkan konflik dengan pengembangan SAP berikutnya.

Untuk memungkinkan perusahaan menambahkan business rule tanpa mengubah source code standar, SAP menyediakan **Enhancement Framework**.

---

# Tujuan

Enhancement Framework memungkinkan programmer menambahkan logika baru ke dalam program SAP tanpa memodifikasi source code standar.

Dengan demikian.

- Program standar SAP tetap terjaga.
- Upgrade sistem menjadi lebih aman.
- Business rule perusahaan dapat diimplementasikan.

---

# Konsep Dasar

Secara sederhana.

```text
Program Standar SAP

↓

Titik Enhancement

↓

Program Custom (Z*)

↓

Program Standar SAP Melanjutkan Eksekusi
```

Program SAP menyediakan lokasi tertentu yang dapat "disisipi" logika tambahan.

---

# Mengapa Tidak Mengubah Source Code SAP?

Misalkan programmer langsung mengubah program SAP.

```
SAP Standard

↓

Ditambah Logic Perusahaan
```

Ketika SAP melakukan upgrade.

```
Program SAP Baru

↓

Perubahan Hilang
```

Selain itu.

- Sulit melakukan maintenance.
- Sulit melakukan troubleshooting.
- Tidak sesuai dengan best practice SAP.

Karena itu, SAP menyediakan Enhancement Framework sebagai mekanisme resmi untuk melakukan kustomisasi.

---

# Jenis Enhancement

Dalam pengembangan ABAP, tiga mekanisme yang paling sering dijumpai adalah.

- User Exit
- BAdI (Business Add-In)
- Enhancement Point

Masing-masing memiliki karakteristik yang berbeda.

---

# User Exit

## Definisi

User Exit merupakan mekanisme klasik SAP untuk menambahkan logika pada lokasi yang telah disediakan oleh SAP.

Program SAP memanggil Function Module tertentu apabila User Exit tersedia.

Contoh alur.

```text
Program SAP

↓

CALL CUSTOMER-FUNCTION

↓

Program Custom

↓

Program SAP
```

User Exit banyak dijumpai pada sistem SAP ECC yang telah lama digunakan.

---

## Kapan Digunakan

Biasanya digunakan apabila sistem yang dikembangkan masih menggunakan enhancement klasik.

---

# BAdI (Business Add-In)

## Definisi

BAdI merupakan mekanisme enhancement berbasis Object-Oriented Programming.

Berbeda dengan User Exit yang menggunakan Function Module, BAdI menggunakan Interface dan Class.

Alur.

```text
Program SAP

↓

BAdI Interface

↓

Implementasi Perusahaan

↓

Program SAP
```

---

## Mengapa SAP Mengembangkan BAdI?

User Exit memiliki beberapa keterbatasan.

- Sulit dikembangkan.
- Kurang fleksibel.
- Tidak mendukung banyak implementasi.

BAdI dirancang untuk mengatasi keterbatasan tersebut.

---

## Struktur BAdI

Secara sederhana.

```
BAdI Definition

↓

Interface

↓

Implementasi Class

↓

Method
```

Program SAP memanggil Interface.

Class milik perusahaan menjalankan implementasi business rule.

---

# Enhancement Point

## Definisi

Enhancement Point merupakan titik tertentu di dalam source code SAP yang disediakan untuk menambahkan logika tambahan.

Contoh.

```abap
ENHANCEMENT-POINT ...

    ...

END-ENHANCEMENT-POINT.
```

Program perusahaan dapat menambahkan statement ABAP pada lokasi tersebut.

---

# Perbandingan

| User Exit | BAdI | Enhancement Point |
|------------|------|-------------------|
| Enhancement klasik | Enhancement modern | Titik penyisipan kode |
| Menggunakan Function Module | Menggunakan Interface dan Class | Menyisipkan kode langsung pada titik yang disediakan |
| Umumnya pada SAP ECC | Digunakan pada SAP ECC dan S/4HANA | Digunakan apabila SAP menyediakan titik enhancement |

---

# Hubungan dengan Business Requirement

Misalkan perusahaan memiliki aturan.

```
Permit harus disetujui sebelum Notification dibuat.
```

Program SAP standar belum memiliki aturan tersebut.

Enhancement digunakan untuk menyisipkan logika berikut.

```text
User Menekan Save

↓

Program SAP

↓

Enhancement

↓

Check Permit

↓

Permit Valid?

↓

Ya

↓

Lanjut Membuat Notification

↓

Tidak

↓

MESSAGE Error
```

Program SAP tidak perlu diubah.

Business rule ditempatkan pada Enhancement.

---

# Hubungan dengan Dokumen Sebelumnya

Seluruh konsep ABAP yang telah dipelajari digunakan di dalam Enhancement.

Sebagai contoh.

```text
Enhancement

↓

SELECT

↓

READ TABLE

↓

LOOP

↓

IF

↓

CALL FUNCTION

↓

MESSAGE

↓

COMMIT WORK
```

Dengan kata lain, Enhancement bukanlah bahasa pemrograman baru.

Enhancement merupakan lokasi tempat program ABAP dijalankan.

---

# Praktik yang Umum Digunakan

Dalam proyek implementasi SAP, alur kerja programmer umumnya adalah.

1. Memahami business requirement.
2. Menentukan transaksi SAP yang terlibat.
3. Mencari Enhancement yang tersedia.
4. Menulis logika ABAP pada Enhancement tersebut.
5. Menguji proses bisnis.

Sebagian besar pekerjaan programmer ABAP berada pada langkah ketiga dan keempat.

---

# Ringkasan

- Enhancement Framework digunakan untuk menambahkan business rule tanpa mengubah source code standar SAP.
- User Exit merupakan mekanisme enhancement klasik.
- BAdI merupakan mekanisme enhancement berbasis OOP.
- Enhancement Point merupakan titik penyisipan kode yang disediakan oleh SAP.
- Seluruh konsep ABAP seperti `SELECT`, `LOOP`, `IF`, `CALL FUNCTION`, dan `MESSAGE` umumnya dijalankan di dalam Enhancement.