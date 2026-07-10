# CALL FUNCTION

## Latar Belakang

Setelah sebuah Function Module dibuat, program memerlukan mekanisme untuk menjalankan fungsi tersebut. Pada ABAP, mekanisme tersebut dilakukan menggunakan statement `CALL FUNCTION`.

Statement ini digunakan untuk memanggil Function Module beserta parameter yang diperlukan. Setelah Function Module selesai dieksekusi, kontrol program akan kembali ke statement berikutnya.

Sebagian besar proses bisnis pada SAP dijalankan melalui `CALL FUNCTION`, baik untuk membaca data, melakukan validasi, maupun menyimpan perubahan ke database.

---

# Tujuan

`CALL FUNCTION` digunakan untuk menjalankan sebuah Function Module dari program ABAP.

Program bertanggung jawab menentukan kapan Function Module dipanggil dan data apa yang dikirimkan.

Implementasi proses bisnis berada di dalam Function Module.

---

# Hubungan dengan Konsep Sebelumnya

Alur umum pada program ABAP.

```text
SELECT

↓

LOOP

↓

IF

↓

CALL FUNCTION

↓

Function Module

↓

Business Logic

↓

Kembali ke Program
```

Program utama bertindak sebagai pengatur alur proses.

Function Module menjalankan proses yang diminta.

---

# Sintaks Dasar

```abap
CALL FUNCTION 'Z_CREATE_NOTIFICATION'.
```

Statement tersebut menjalankan Function Module bernama `Z_CREATE_NOTIFICATION`.

---

# Pemanggilan dengan Parameter

Pada praktiknya, hampir seluruh Function Module membutuhkan parameter.

Contoh.

```abap
CALL FUNCTION 'Z_CREATE_NOTIFICATION'

    EXPORTING

        iv_equnr = ls_motor-equnr.
```

Program mengirim nilai Equipment Number ke Function Module.

---

## Contoh dengan Parameter Lengkap

```abap
CALL FUNCTION 'Z_CREATE_NOTIFICATION'

    EXPORTING

        iv_equnr = ls_motor-equnr

        iv_user = sy-uname

    IMPORTING

        ev_notification = lv_notification

    TABLES

        et_return = lt_return.
```

Pada contoh tersebut.

Program mengirim:

- Equipment Number
- Username

Function Module mengembalikan:

- Nomor Notification
- Daftar pesan proses

---

# Cara Kerja

Misalkan program memiliki data berikut.

```
Equipment Number

↓

MTR001
```

Program menjalankan.

```abap
CALL FUNCTION 'Z_CREATE_NOTIFICATION'

    EXPORTING

        iv_equnr = ls_motor-equnr.
```

Alur proses.

```text
Program

↓

CALL FUNCTION

↓

Function Module menerima Equipment Number

↓

Business Logic dijalankan

↓

Function Module selesai

↓

Program melanjutkan eksekusi
```

Program tidak mengetahui bagaimana Notification dibuat.

Seluruh implementasi berada di dalam Function Module.

---

# Contoh Kasus SAP PM

Business Requirement.

> Buat Notification apabila Equipment mengalami TRIP dan belum memiliki Notification aktif.

Implementasi.

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

Pada contoh tersebut.

Program terlebih dahulu memastikan bahwa Notification belum ada.

Apabila belum ada, Function Module dipanggil.

---

# CALL FUNCTION di Dalam LOOP

`CALL FUNCTION` sering dijumpai di dalam `LOOP`.

Contoh.

```abap
LOOP AT lt_motor INTO ls_motor.

    IF ls_motor-status = 'TRIP'.

        CALL FUNCTION 'Z_CHECK_PERMIT'

            EXPORTING

                iv_equnr = ls_motor-equnr.

    ENDIF.

ENDLOOP.
```

Pada contoh tersebut.

Setiap Equipment diperiksa satu per satu.

Function Module dipanggil hanya apabila memenuhi kondisi yang ditentukan.

---

# Hubungan dengan Business Rule

Program utama bertanggung jawab mengevaluasi business rule.

Function Module bertanggung jawab menjalankan proses bisnis.

Contoh.

Business Rule.

```
Running Hour lebih dari 6000 jam.
```

Program.

```abap
IF ls_motor-running_hour >= 6000.

    CALL FUNCTION 'Z_CREATE_WORKORDER'.

ENDIF.
```

Program menentukan kapan Work Order dibuat.

Cara pembuatan Work Order berada di dalam Function Module.

---

# CALL FUNCTION vs PERFORM

Keduanya sama-sama digunakan untuk menjalankan blok program.

Perbedaannya.

| PERFORM | CALL FUNCTION |
|----------|---------------|
| Memanggil subroutine (`FORM`) | Memanggil Function Module |
| Hanya dapat digunakan pada program yang sama | Dapat digunakan dari berbagai program |
| Digunakan untuk membagi struktur program | Digunakan untuk menggunakan fungsi yang telah tersedia |

---

# Pemeriksaan Hasil Eksekusi

Beberapa Function Module memberikan informasi keberhasilan melalui parameter output.

Contoh.

```abap
CALL FUNCTION 'Z_CREATE_NOTIFICATION'

    IMPORTING

        ev_notification = lv_notification.
```

Beberapa Function Module juga menggunakan `SY-SUBRC`.

```abap
CALL FUNCTION 'Z_CHECK_PERMIT'.

IF sy-subrc <> 0.

    MESSAGE 'Permit tidak valid' TYPE 'E'.

ENDIF.
```

Mekanisme yang digunakan bergantung pada implementasi Function Module.

---

# Kesalahan yang Sering Terjadi

## Memanggil Function Module Tanpa Validasi

```abap
CALL FUNCTION 'Z_CREATE_NOTIFICATION'.
```

Pendekatan tersebut dapat menyebabkan Notification dibuat meskipun business rule belum terpenuhi.

Validasi sebaiknya dilakukan sebelum `CALL FUNCTION`.

---

## Menempatkan Business Rule di Dalam Program dan Function Module Sekaligus

Misalnya.

Program memeriksa Running Hour.

Function Module juga memeriksa Running Hour.

Apabila business rule yang sama ditulis pada dua tempat, proses pemeliharaan menjadi lebih sulit.

Pembagian tanggung jawab antara Program dan Function Module perlu ditentukan dengan jelas.

---

# Praktik yang Umum Digunakan

Struktur program yang sering dijumpai.

```abap
LOOP AT lt_motor INTO ls_motor.

    IF ls_motor-status = 'TRIP'.

        READ TABLE lt_notification
        INTO ls_notification
        WITH KEY equnr = ls_motor-equnr.

        IF sy-subrc <> 0.

            CALL FUNCTION 'Z_CREATE_NOTIFICATION'

                EXPORTING

                    iv_equnr = ls_motor-equnr.

        ENDIF.

    ENDIF.

ENDLOOP.
```

Program utama mengatur urutan proses.

Function Module menjalankan proses bisnis.

---

# Ringkasan

- `CALL FUNCTION` digunakan untuk menjalankan Function Module.
- Program menentukan kapan Function Module dipanggil.
- Data dikirim menggunakan parameter seperti `EXPORTING`, sedangkan hasil dapat diterima melalui `IMPORTING` atau mekanisme lain yang disediakan Function Module.
- Business rule sebaiknya dievaluasi sebelum `CALL FUNCTION` dijalankan.
- `CALL FUNCTION` merupakan salah satu statement yang paling sering dijumpai pada pengembangan aplikasi SAP.