# Function Module

## Latar Belakang

Seiring berkembangnya sistem SAP, banyak fungsi yang dibutuhkan oleh berbagai program memiliki implementasi yang sama. Contohnya adalah membuat Notification, membuat Work Order, membaca master data Equipment, mengirim e-mail, atau melakukan validasi tertentu.

Apabila setiap programmer menulis ulang fungsi tersebut pada setiap program menggunakan `FORM`, akan muncul banyak duplikasi kode yang sulit dipelihara.

Untuk mengatasi hal tersebut, SAP menyediakan **Function Module**, yaitu sekumpulan logika yang disimpan secara terpusat dan dapat dipanggil oleh berbagai program.

Function Module merupakan salah satu komponen dasar ABAP yang digunakan untuk membangun fungsi-fungsi bisnis yang dapat digunakan kembali (reusable).

---

## Tujuan

Function Module digunakan untuk menyediakan suatu fungsi yang dapat dipanggil dari berbagai program ABAP tanpa perlu menuliskan ulang implementasinya.

Contoh penggunaan Function Module pada SAP PM:

- Membuat Notification.
- Membuat Work Order.
- Membaca data Equipment.
- Melakukan validasi tertentu.
- Menyimpan perubahan ke database.

---

## Hubungan dengan Konsep Sebelumnya

Pada materi sebelumnya digunakan `PERFORM`.

```abap
PERFORM create_notification.
```

`PERFORM` hanya dapat memanggil subroutine (`FORM`) yang berada pada program yang sama.

Apabila fungsi tersebut perlu digunakan oleh banyak program, maka logika dipindahkan menjadi Function Module.

Alur penggunaannya menjadi.

```text
Program A
        │
        ├────────────┐
        ▼            │
CALL FUNCTION        │
        ▼            │
Function Module      │
        ▲            │
        └────────────┤
                     ▼
                Program B

                     │
                     ▼
               CALL FUNCTION
```

Satu Function Module dapat digunakan oleh banyak program.

---

## Struktur Dasar

Pemanggilan Function Module dilakukan menggunakan statement berikut.

```abap
CALL FUNCTION '<Function Module Name>'.
```

Contoh.

```abap
CALL FUNCTION 'Z_CREATE_NOTIFICATION'.
```

Pada contoh tersebut, program meminta SAP menjalankan Function Module bernama `Z_CREATE_NOTIFICATION`.

Huruf **Z** menunjukkan bahwa Function Module tersebut merupakan objek yang dibuat oleh perusahaan (custom object), bukan bawaan SAP.

---

## Parameter pada Function Module

Function Module umumnya menerima data dari program yang memanggilnya.

Parameter tersebut dikelompokkan menjadi beberapa bagian.

### EXPORTING

Mengirim data dari program menuju Function Module.

Contoh.

```abap
CALL FUNCTION 'Z_CREATE_NOTIFICATION'

    EXPORTING

        iv_equnr = ls_motor-equnr.
```

Pada contoh tersebut.

Program mengirim Equipment Number menuju Function Module.

```
Program
        │
        ▼
Equipment Number
        │
        ▼
Function Module
```

---

### IMPORTING

Menerima hasil yang dikembalikan oleh Function Module.

Contoh.

```abap
CALL FUNCTION 'Z_READ_EQUIPMENT'

    IMPORTING

        ev_status = lv_status.
```

Setelah Function Module selesai dijalankan, nilai status disimpan ke variabel `lv_status`.

```
Function Module

        │

        ▼

Program
```

---

### TABLES

Digunakan apabila Function Module menerima atau mengembalikan Internal Table.

Contoh.

```abap
CALL FUNCTION 'Z_READ_NOTIFICATION'

    TABLES

        et_notification = lt_notification.
```

---

### CHANGING

Digunakan apabila parameter dapat diubah oleh Function Module.

Nilai awal dikirim dari program, kemudian dapat dimodifikasi selama Function Module berjalan.

---

## Contoh Kasus SAP PM

Business Requirement.

> Program harus membuat Notification untuk Equipment yang mengalami TRIP.

Program utama.

```abap
LOOP AT lt_motor INTO ls_motor.

    IF ls_motor-status = 'TRIP'.

        CALL FUNCTION 'Z_CREATE_NOTIFICATION'

            EXPORTING

                iv_equnr = ls_motor-equnr.

    ENDIF.

ENDLOOP.
```

Pada contoh tersebut.

Program tidak mengetahui bagaimana Notification dibuat.

Program hanya mengirim Equipment Number.

Seluruh proses pembuatan Notification berada di dalam Function Module.

---

## Mengapa Menggunakan Function Module?

Misalkan terdapat tiga program.

- Program Monitoring
- Program Preventive Maintenance
- Program Breakdown Maintenance

Ketiganya membutuhkan proses pembuatan Notification.

Apabila masing-masing program menulis logika sendiri, maka setiap perubahan harus dilakukan pada tiga tempat yang berbeda.

Dengan Function Module.

```text
Program Monitoring
            │
            │
            ├──────────────┐
            ▼              │
                     Function Module
            ▲              │
            └──────────────┤
            │              │
Program PM   │     Program Breakdown
```

Logika hanya berada pada satu lokasi.

Apabila terdapat perubahan business rule, perubahan cukup dilakukan pada Function Module tersebut.

---

## Function Module vs PERFORM

| PERFORM | Function Module |
|----------|-----------------|
| Memanggil `FORM` | Memanggil Function Module |
| Berlaku pada satu program | Dapat dipanggil dari berbagai program |
| Digunakan untuk membagi struktur program | Digunakan untuk menyediakan fungsi yang dapat digunakan kembali |
| Tidak memiliki interface formal | Memiliki parameter yang terstruktur (`EXPORTING`, `IMPORTING`, `TABLES`, `CHANGING`) |

Secara umum.

- Gunakan `PERFORM` untuk membagi logika di dalam satu program.
- Gunakan Function Module apabila fungsi tersebut perlu digunakan oleh banyak program.

---

## Praktik yang Umum Digunakan

Program utama biasanya hanya menentukan kapan Function Module dipanggil.

```abap
IF ls_motor-status = 'TRIP'.

    CALL FUNCTION 'Z_CREATE_NOTIFICATION'

        EXPORTING

            iv_equnr = ls_motor-equnr.

ENDIF.
```

Seluruh implementasi pembuatan Notification berada di dalam Function Module.

Dengan demikian, program utama tetap ringkas dan lebih mudah dibaca.

---

## Kesalahan yang Sering Terjadi

### Menuliskan Business Logic yang Sama pada Banyak Program

Apabila logika yang sama digunakan oleh beberapa program, sebaiknya dipindahkan menjadi Function Module.

---

### Menganggap Function Module Sama dengan PERFORM

Keduanya sama-sama menjalankan blok program, tetapi memiliki cakupan yang berbeda.

`PERFORM` hanya dapat digunakan pada program yang sama.

Function Module dapat digunakan oleh berbagai program di seluruh sistem SAP.

---

## Ringkasan

- Function Module merupakan fungsi yang dapat digunakan kembali oleh berbagai program ABAP.
- Function Module dipanggil menggunakan `CALL FUNCTION`.
- Parameter dikirim menggunakan `EXPORTING`, `IMPORTING`, `TABLES`, atau `CHANGING`.
- Business logic yang digunakan oleh banyak program sebaiknya ditempatkan pada Function Module.
- `PERFORM` digunakan untuk organisasi kode dalam satu program, sedangkan Function Module digunakan untuk berbagi fungsi antarprogram.