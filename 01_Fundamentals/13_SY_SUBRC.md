# SY-SUBRC

## Latar Belakang

Pada banyak bahasa pemrograman, suatu operasi biasanya mengembalikan nilai `true` atau `false` untuk menunjukkan apakah operasi tersebut berhasil.

ABAP menggunakan pendekatan yang berbeda. Setelah suatu statement selesai dieksekusi, sistem akan mengisi sebuah **System Field** bernama `SY-SUBRC`.

Nilai `SY-SUBRC` menunjukkan apakah statement sebelumnya berhasil dijalankan atau tidak. Oleh karena itu, pemeriksaan `SY-SUBRC` menjadi salah satu pola yang paling sering dijumpai pada source code ABAP.

---

# Tujuan

`SY-SUBRC` digunakan untuk mengetahui hasil eksekusi statement yang baru saja dijalankan.

Program dapat menggunakan nilai tersebut untuk menentukan proses selanjutnya.

---

# Apa itu System Field?

System Field adalah sekumpulan variabel yang disediakan oleh sistem SAP dan dapat diakses langsung oleh program ABAP.

Contohnya.

| System Field | Fungsi |
|--------------|--------|
| SY-SUBRC | Status hasil eksekusi statement sebelumnya |
| SY-UNAME | Username yang sedang login |
| SY-DATUM | Tanggal sistem |
| SY-UZEIT | Waktu sistem |

Dokumen ini hanya membahas `SY-SUBRC`.

---

# Cara Kerja

Alur kerja `SY-SUBRC` secara umum.

```text
Statement ABAP

↓

SAP Mengeksekusi Statement

↓

SY-SUBRC diperbarui

↓

Program memeriksa nilai SY-SUBRC

↓

Menentukan langkah berikutnya
```

Nilai `SY-SUBRC` selalu mengacu pada **statement yang dieksekusi tepat sebelumnya**.

---

# Nilai SY-SUBRC

Nilai yang paling sering dijumpai adalah.

| Nilai | Arti |
|--------|------|
| 0 | Operasi berhasil |
| Selain 0 | Operasi tidak berhasil atau data tidak ditemukan |

Untuk sebagian besar program ABAP, pemeriksaan hanya dilakukan terhadap dua kondisi tersebut.

---

# Contoh pada READ TABLE

Misalkan terdapat Internal Table Notification.

| NOTIF_NO | EQUNR |
|----------|--------|
|1001|MTR001|
|1002|MTR003|

Program mencari Notification milik MTR003.

```abap
READ TABLE lt_notification
INTO ls_notification
WITH KEY equnr = 'MTR003'.
```

Karena data ditemukan.

```
SY-SUBRC = 0
```

Program kemudian dapat melanjutkan proses.

```abap
IF sy-subrc = 0.

    " Notification ditemukan

ENDIF.
```

---

## Data Tidak Ditemukan

Program mencari Notification milik MTR005.

```abap
READ TABLE lt_notification
INTO ls_notification
WITH KEY equnr = 'MTR005'.
```

Karena data tidak ditemukan.

```
SY-SUBRC <> 0
```

Program dapat menjalankan proses lain.

```abap
IF sy-subrc <> 0.

    PERFORM create_notification.

ENDIF.
```

Pola tersebut sangat sering digunakan pada SAP PM untuk menghindari pembuatan Notification ganda.

---

# Contoh pada SELECT

Misalkan database tidak memiliki Equipment dengan nomor tertentu.

```abap
SELECT SINGLE *
FROM zequipment
INTO ls_motor
WHERE equnr = 'MTR999'.
```

Apabila data tidak ditemukan.

```
SY-SUBRC <> 0
```

Program dapat memberikan pesan kepada pengguna atau menghentikan proses.

---

# Contoh pada CALL FUNCTION

Beberapa Function Module juga menggunakan `SY-SUBRC` untuk menunjukkan hasil eksekusi.

```abap
CALL FUNCTION 'Z_CHECK_PERMIT'.

IF sy-subrc <> 0.

    MESSAGE 'Permit tidak valid' TYPE 'E'.

ENDIF.
```

Perlu diperhatikan bahwa tidak semua Function Module menggunakan `SY-SUBRC` sebagai indikator keberhasilan. Sebagian Function Module mengembalikan status melalui parameter `EXPORTING`, `IMPORTING`, atau `RETURN`.

Dokumentasi Function Module perlu diperiksa untuk mengetahui mekanisme yang digunakan.

---

# Mengapa Harus Segera Diperiksa?

Nilai `SY-SUBRC` selalu diperbarui setelah statement tertentu dijalankan.

Contoh.

```abap
READ TABLE lt_notification
INTO ls_notification
WITH KEY equnr = ls_motor-equnr.

IF sy-subrc = 0.

    ...

ENDIF.
```

Pendekatan tersebut benar karena `SY-SUBRC` langsung diperiksa setelah `READ TABLE`.

Sebaliknya.

```abap
READ TABLE lt_notification
INTO ls_notification
WITH KEY equnr = ls_motor-equnr.

WRITE ls_motor-equnr.

IF sy-subrc = 0.

ENDIF.
```

Pendekatan tersebut berisiko karena statement lain dapat mengubah nilai `SY-SUBRC` sebelum diperiksa.

Oleh karena itu, praktik yang umum digunakan adalah memeriksa `SY-SUBRC` segera setelah statement yang ingin dievaluasi.

---

# Praktik yang Umum Digunakan

Pola berikut merupakan salah satu pola yang paling sering dijumpai pada source code SAP.

```abap
READ TABLE lt_notification
INTO ls_notification
WITH KEY equnr = ls_motor-equnr.

IF sy-subrc <> 0.

    CALL FUNCTION 'Z_CREATE_NOTIFICATION'

        EXPORTING

            iv_equnr = ls_motor-equnr.

ENDIF.
```

Business Rule.

> Apabila Notification belum ada, buat Notification baru.

`READ TABLE` digunakan untuk mencari Notification.

`SY-SUBRC` digunakan untuk menentukan apakah Notification ditemukan.

---

# Kesalahan yang Sering Terjadi

## Tidak Memeriksa SY-SUBRC

```abap
READ TABLE lt_notification
INTO ls_notification
WITH KEY equnr = ls_motor-equnr.

CALL FUNCTION 'Z_CREATE_NOTIFICATION'.
```

Program selalu membuat Notification baru meskipun Notification sebelumnya sudah ada.

---

## Memeriksa Terlambat

```abap
READ TABLE ...

...

...

IF sy-subrc = 0.
```

Semakin banyak statement yang dijalankan sebelum pemeriksaan, semakin besar kemungkinan nilai `SY-SUBRC` sudah berubah.

---

# Ringkasan

- `SY-SUBRC` merupakan System Field yang menunjukkan hasil eksekusi statement sebelumnya.
- Nilai `0` menunjukkan operasi berhasil.
- Nilai selain `0` menunjukkan operasi tidak berhasil atau data tidak ditemukan.
- `SY-SUBRC` paling sering digunakan setelah `READ TABLE`, `SELECT`, dan beberapa `CALL FUNCTION`.
- Pemeriksaan `SY-SUBRC` sebaiknya dilakukan segera setelah statement yang ingin dievaluasi.