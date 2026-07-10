# PERFORM

## Latar Belakang

Seiring bertambahnya kompleksitas program ABAP, seluruh logika tidak lagi ditulis dalam satu blok program. Penulisan program yang terlalu panjang akan menyulitkan proses pembacaan, pemeliharaan, maupun pengembangan fitur baru.

Untuk mengatasi hal tersebut, program dipecah menjadi beberapa subroutine yang masing-masing memiliki tanggung jawab tertentu. Statement `PERFORM` digunakan untuk memanggil subroutine tersebut.

Pada source code ABAP klasik, penggunaan `PERFORM` merupakan pola yang sangat umum dijumpai.

---

## Tujuan

`PERFORM` digunakan untuk menjalankan sebuah subroutine (`FORM`) yang telah didefinisikan pada program yang sama.

Dengan memisahkan logika ke dalam beberapa subroutine, struktur program menjadi lebih terorganisasi dan mudah dipelihara.

---

## Hubungan dengan Konsep Sebelumnya

Business logic yang berada di dalam `LOOP`, `IF`, maupun proses validasi sering dipindahkan ke dalam subroutine agar program utama tetap ringkas.

Alur program umumnya menjadi.

```text
START

↓

PERFORM Read Data

↓

PERFORM Validation

↓

PERFORM Business Process

↓

PERFORM Save Data

↓

END
```

---

## Sintaks Dasar

Pemanggilan.

```abap
PERFORM check_permit.
```

Definisi subroutine.

```abap
FORM check_permit.

    ...

ENDFORM.
```

---

## Cara Kerja

Ketika program menemukan statement

```abap
PERFORM check_permit.
```

eksekusi program berpindah menuju

```abap
FORM check_permit.

    ...

ENDFORM.
```

Setelah seluruh isi `FORM` selesai dijalankan, eksekusi kembali ke baris setelah `PERFORM`.

Alur tersebut dapat digambarkan sebagai berikut.

```text
Program Utama

↓

PERFORM check_permit

↓

FORM check_permit

↓

ENDFORM

↓

Kembali ke Program Utama
```

---

## Contoh

Program utama.

```abap
FORM process_motor.

    PERFORM check_permit.

    PERFORM create_notification.

    WRITE 'Finish'.

ENDFORM.
```

Subroutine pertama.

```abap
FORM check_permit.

    IF ls_motor-permit IS INITIAL.

        MESSAGE 'Permit Required' TYPE 'E'.

    ENDIF.

ENDFORM.
```

Subroutine kedua.

```abap
FORM create_notification.

    CALL FUNCTION 'Z_CREATE_NOTIFICATION'.

ENDFORM.
```

Urutan eksekusi.

```text
process_motor

↓

check_permit

↓

kembali

↓

create_notification

↓

kembali

↓

WRITE 'Finish'
```

---

## Kapan Menggunakan PERFORM

`PERFORM` digunakan ketika suatu logika:

- digunakan lebih dari satu kali;
- cukup panjang sehingga sebaiknya dipisahkan;
- memiliki tanggung jawab yang jelas, misalnya validasi, pembacaan data, atau penyimpanan data.

Contoh nama subroutine yang umum dijumpai.

- `read_equipment`
- `check_authorization`
- `check_permit`
- `create_notification`
- `save_data`
- `display_result`

---

## Contoh Struktur Program

```abap
FORM process_motor.

    PERFORM read_equipment.

    PERFORM check_status.

    PERFORM check_running_hour.

    PERFORM create_notification.

    PERFORM save_log.

ENDFORM.
```

Pada contoh tersebut, program utama hanya berisi urutan proses bisnis.

Implementasi setiap proses dipindahkan ke subroutine masing-masing.

---

## PERFORM vs CALL FUNCTION

Keduanya sama-sama digunakan untuk menjalankan blok program, tetapi memiliki cakupan yang berbeda.

| PERFORM | CALL FUNCTION |
|----------|---------------|
| Memanggil subroutine (`FORM`) | Memanggil Function Module |
| Hanya dapat digunakan pada program yang sama | Dapat dipanggil dari program lain |
| Digunakan untuk membagi struktur program | Digunakan untuk menyediakan fungsi yang dapat digunakan kembali |

Secara umum, `PERFORM` digunakan untuk organisasi kode, sedangkan `CALL FUNCTION` digunakan untuk menjalankan fungsi yang memang disediakan sebagai modul terpisah.

---

## Praktik yang Umum Digunakan

Program utama umumnya hanya berisi alur proses.

```abap
FORM process.

    PERFORM read_data.

    PERFORM validate_data.

    PERFORM process_data.

    PERFORM save_data.

ENDFORM.
```

Pendekatan tersebut membuat source code lebih mudah dibaca karena setiap subroutine memiliki tanggung jawab yang jelas.

---

## Ringkasan

- `PERFORM` digunakan untuk memanggil subroutine (`FORM`).
- `FORM` berisi satu kelompok logika yang memiliki tujuan tertentu.
- Setelah `FORM` selesai dijalankan, eksekusi kembali ke baris setelah `PERFORM`.
- `PERFORM` membantu memecah program menjadi bagian-bagian yang lebih terstruktur.
- `PERFORM` berbeda dengan `CALL FUNCTION` karena hanya berlaku di dalam program yang sama.