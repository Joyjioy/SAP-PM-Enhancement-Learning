# SELECT

## Latar Belakang

Sebagian besar program ABAP diawali dengan proses pembacaan data dari database SAP. Data tersebut kemudian digunakan sebagai dasar pengambilan keputusan sesuai business requirement yang diimplementasikan.

Statement `SELECT` digunakan untuk mengambil data dari database menuju program ABAP. Setelah data berhasil dibaca, proses berikutnya umumnya dilakukan terhadap Internal Table sehingga database tidak perlu diakses kembali.

---

## Tujuan

`SELECT` digunakan untuk mengambil data dari database SAP berdasarkan kriteria tertentu.

Hasil pembacaan dapat disimpan ke:

- Work Area (satu record)
- Internal Table (banyak record)

Pada pengembangan program SAP PM, hasil `SELECT` paling sering disimpan ke Internal Table karena data biasanya akan diproses menggunakan `LOOP`.

---

## Sintaks Dasar

Mengambil banyak data.

```abap
SELECT *
  FROM zequipment
  INTO TABLE lt_motor.
```

Mengambil data berdasarkan kriteria.

```abap
SELECT *
  FROM zequipment
  INTO TABLE lt_motor
  WHERE voltage >= 1000.
```

---

## Penjelasan Sintaks

### FROM

Menentukan tabel database yang akan dibaca.

Contoh.

```abap
FROM zequipment
```

Program membaca data dari tabel `zequipment`.

---

### INTO TABLE

Menentukan Internal Table yang akan menerima hasil pembacaan.

```abap
INTO TABLE lt_motor
```

Seluruh record yang memenuhi kriteria akan disimpan ke dalam `lt_motor`.

---

### WHERE

Menentukan kriteria data yang akan diambil dari database.

Contoh.

```abap
WHERE voltage >= 1000
```

Artinya hanya Equipment dengan tegangan minimal 1000 Volt yang dikirim ke program.

Contoh lain.

```abap
WHERE status = 'TRIP'
```

Artinya hanya Equipment dengan status TRIP yang diambil.

Kriteria dapat digabungkan.

```abap
WHERE voltage >= 1000
AND status = 'TRIP'
```

---

## Alur Kerja

Misalkan database memiliki data berikut.

| EQUNR | VOLTAGE | STATUS |
|-------|----------|---------|
|MTR001|6000|TRIP|
|MTR002|380|RUNNING|
|MTR003|6000|RUNNING|

Program menjalankan.

```abap
SELECT *
  FROM zequipment
  INTO TABLE lt_motor
  WHERE voltage >= 1000.
```

Isi Internal Table menjadi.

| EQUNR | VOLTAGE | STATUS |
|-------|----------|---------|
|MTR001|6000|TRIP|
|MTR003|6000|RUNNING|

Equipment MTR002 tidak ikut dimasukkan karena tidak memenuhi kondisi `WHERE`.

---

## SELECT dan Business Requirement

Business Requirement menentukan kondisi pada `WHERE`.

Contoh.

Business Requirement:

> Program hanya memproses Motor Medium Voltage.

Implementasi.

```abap
WHERE voltage >= 1000
```

Business Requirement:

> Program hanya memproses Notification yang masih OPEN.

Implementasi.

```abap
WHERE status = 'OPEN'
```

Business Requirement:

> Program hanya memproses Motor Siemens.

Implementasi.

```abap
WHERE manufacturer = 'SIEMENS'
```

Dengan demikian, `WHERE` merupakan representasi langsung dari business requirement yang dapat diputuskan oleh database.

---

## WHERE vs WITH KEY

Keduanya sama-sama digunakan untuk mencari data, tetapi pada lokasi yang berbeda.

### WHERE

Digunakan ketika data masih berada di database.

```abap
SELECT *
FROM zequipment
WHERE voltage >= 1000.
```

Database melakukan pencarian kemudian mengirimkan hasilnya ke program.

---

### WITH KEY

Digunakan ketika data sudah berada di Internal Table.

```abap
READ TABLE lt_motor
INTO ls_motor
WITH KEY equnr = 'MTR001'.
```

Program melakukan pencarian terhadap data yang sudah berada di memori.

---

## Hubungan SELECT dengan Internal Table

Alur pengolahan data pada ABAP umumnya mengikuti pola berikut.

```text
Database

        │

        ▼

SELECT ... WHERE

        │

        ▼

Internal Table

        │

        ▼

LOOP

        │

        ▼

READ TABLE

        │

        ▼

Business Logic
```

Program yang telah memiliki seluruh data di Internal Table sebaiknya tidak lagi melakukan `SELECT` yang sama secara berulang.

---

## Praktik yang Umum Digunakan

Lakukan `SELECT` satu kali untuk mengambil seluruh data yang diperlukan.

Selanjutnya gunakan Internal Table sebagai sumber data utama selama proses bisnis berlangsung.

Pendekatan ini mengurangi jumlah akses ke database dan meningkatkan performa program.

---

## Kesalahan yang Sering Terjadi

### Melakukan SELECT di dalam LOOP

Contoh.

```abap
LOOP AT lt_motor INTO ls_motor.

    SELECT ...

ENDLOOP.
```

Pendekatan tersebut menyebabkan database diakses berulang kali.

Apabila data yang dibutuhkan dapat diambil di awal program, lebih baik lakukan satu kali `SELECT`, kemudian gunakan `READ TABLE` atau `LOOP` terhadap Internal Table.

---

## Ringkasan

- `SELECT` digunakan untuk membaca data dari database SAP.
- Hasil pembacaan umumnya disimpan ke Internal Table.
- `WHERE` digunakan untuk menentukan record yang akan diambil dari database.
- Business requirement yang dapat diputuskan langsung oleh database sebaiknya ditempatkan pada `WHERE`.
- Setelah data berada di Internal Table, proses berikutnya dilakukan menggunakan `LOOP` atau `READ TABLE`.