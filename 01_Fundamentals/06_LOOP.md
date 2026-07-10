# LOOP

## Latar Belakang

Setelah data berhasil dibaca dari database menggunakan `SELECT`, seluruh record disimpan ke dalam Internal Table. Pada kondisi tersebut, program belum melakukan pemrosesan apa pun terhadap data. Seluruh record hanya berada di memori dan menunggu untuk diproses.

Agar setiap record dapat diperiksa atau dimodifikasi, program harus mengaksesnya satu per satu. Statement `LOOP` digunakan untuk melakukan proses tersebut.

Sebagian besar business logic pada program ABAP dijalankan di dalam `LOOP`.

---

## Tujuan

`LOOP` digunakan untuk melakukan iterasi terhadap seluruh record pada Internal Table.

Pada setiap iterasi, satu record dipindahkan ke Work Area sehingga dapat diproses oleh program.

---

## Hubungan dengan Konsep Sebelumnya

Alur umum pengolahan data pada ABAP adalah sebagai berikut.

```text
Database
    │
    ▼
SELECT
    │
    ▼
Internal Table (lt_*)
    │
    ▼
LOOP
    │
    ▼
Work Area (ls_*)
    │
    ▼
Business Logic
```

`SELECT` menghasilkan Internal Table.

`LOOP` membaca Internal Table.

Business Logic dijalankan terhadap Work Area.

---

## Sintaks Dasar

```abap
LOOP AT lt_motor INTO ls_motor.

ENDLOOP.
```

---

## Penjelasan Sintaks

### LOOP AT

Menentukan Internal Table yang akan diproses.

```abap
LOOP AT lt_motor
```

Program akan membaca seluruh record pada `lt_motor` secara berurutan.

---

### INTO

Menentukan Work Area yang akan digunakan.

```abap
INTO ls_motor
```

Pada setiap iterasi, satu record dipindahkan ke `ls_motor`.

Seluruh proses berikutnya dilakukan terhadap `ls_motor`.

---

## Cara Kerja

Misalkan Internal Table memiliki data berikut.

| EQUNR | STATUS | VOLTAGE |
|-------|--------|----------|
|MTR001|TRIP|6000|
|MTR002|RUNNING|380|
|MTR003|TRIP|6000|

Program menjalankan.

```abap
LOOP AT lt_motor INTO ls_motor.

ENDLOOP.
```

Urutan proses yang terjadi.

### Iterasi 1

```
ls_motor

EQUNR = MTR001
STATUS = TRIP
VOLTAGE = 6000
```

---

### Iterasi 2

```
ls_motor

EQUNR = MTR002
STATUS = RUNNING
VOLTAGE = 380
```

---

### Iterasi 3

```
ls_motor

EQUNR = MTR003
STATUS = TRIP
VOLTAGE = 6000
```

Setelah iterasi terakhir selesai, `LOOP` berakhir dan program melanjutkan ke statement berikutnya.

---

## LOOP sebagai Tempat Business Logic

Pada sebagian besar program ABAP, keputusan bisnis dilakukan di dalam `LOOP`.

Contoh.

Business Requirement.

> Semua Motor Medium Voltage yang berstatus TRIP harus dibuatkan Notification.

Implementasi.

```abap
LOOP AT lt_motor INTO ls_motor.

    IF ls_motor-voltage >= 1000
    AND ls_motor-status = 'TRIP'.

        PERFORM create_notification.

    ENDIF.

ENDLOOP.
```

Pada contoh tersebut, setiap motor diperiksa satu per satu.

Program hanya menjalankan `create_notification` apabila kedua kondisi terpenuhi.

---

## Kapan Menggunakan WHERE pada LOOP

`LOOP` juga dapat menggunakan `WHERE`.

Contoh.

```abap
LOOP AT lt_motor
INTO ls_motor
WHERE status = 'TRIP'.

ENDLOOP.
```

Pada contoh tersebut, hanya record dengan status `TRIP` yang diproses.

Record lain dilewati.

Perlu diperhatikan bahwa `WHERE` pada `LOOP` berbeda dengan `WHERE` pada `SELECT`.

| Statement | Data yang Diproses |
|-----------|--------------------|
| SELECT ... WHERE | Database |
| LOOP ... WHERE | Internal Table |

Meskipun menggunakan keyword yang sama, lokasi pencarian berbeda.

---

## LOOP dan READ TABLE

`LOOP` dan `READ TABLE` memiliki tujuan yang berbeda.

### LOOP

Digunakan ketika seluruh record perlu diproses.

Contoh.

- Memeriksa seluruh Motor.
- Menghitung jumlah Equipment.
- Membuat Notification untuk semua Motor yang memenuhi syarat.

---

### READ TABLE

Digunakan ketika hanya diperlukan satu record tertentu.

Contoh.

- Mencari Notification milik satu Equipment.
- Mencari Permit berdasarkan Equipment Number.
- Memeriksa apakah Work Order sudah ada.

---

## Kesalahan yang Sering Terjadi

### Mengubah Internal Table saat sedang melakukan LOOP

Perubahan terhadap Internal Table yang sedang diiterasi harus dilakukan dengan hati-hati karena dapat memengaruhi urutan iterasi.

Apabila hanya perlu memeriksa data, gunakan Work Area.

Apabila perlu memperbarui data, gunakan `MODIFY` setelah perubahan dilakukan pada Work Area.

Topik mengenai `MODIFY` dibahas pada dokumen **MODIFY.md**.

---

### Melakukan SELECT pada setiap iterasi

Contoh.

```abap
LOOP AT lt_motor INTO ls_motor.

    SELECT ...

ENDLOOP.
```

Pendekatan tersebut menyebabkan database diakses berulang kali dan menurunkan performa program.

Apabila memungkinkan, lakukan `SELECT` satu kali sebelum `LOOP`, kemudian gunakan `READ TABLE` terhadap Internal Table yang sudah tersedia.

---

## Praktik yang Umum Digunakan

Urutan yang paling sering dijumpai pada program ABAP adalah sebagai berikut.

```abap
SELECT ...
INTO TABLE lt_motor.

LOOP AT lt_motor INTO ls_motor.

    ...

ENDLOOP.
```

Apabila business logic membutuhkan data dari Internal Table lain, gunakan `READ TABLE` di dalam `LOOP`.

Contoh.

```abap
LOOP AT lt_motor INTO ls_motor.

    READ TABLE lt_notification
    INTO ls_notification
    WITH KEY equnr = ls_motor-equnr.

ENDLOOP.
```

Pola tersebut banyak digunakan pada program SAP PM untuk menghubungkan Equipment, Notification, Work Order, maupun Permit.

---

## Ringkasan

- `LOOP` digunakan untuk memproses seluruh record pada Internal Table.
- Setiap iterasi memindahkan satu record ke Work Area.
- Sebagian besar business logic dijalankan di dalam `LOOP`.
- `READ TABLE` sering digunakan di dalam `LOOP` untuk mencari data yang berkaitan dengan record yang sedang diproses.
- Hindari melakukan `SELECT` berulang kali di dalam `LOOP` apabila data sudah tersedia di Internal Table.