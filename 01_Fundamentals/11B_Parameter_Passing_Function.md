# Parameter Passing pada Function Module

## Latar Belakang

Function Module merupakan sebuah blok program yang dirancang untuk digunakan kembali oleh berbagai program ABAP. Agar Function Module dapat menerima data dari program yang memanggilnya maupun mengembalikan hasil pemrosesan, diperlukan mekanisme pertukaran data.

Mekanisme tersebut disebut **Parameter Passing**.

Parameter Passing mendefinisikan bagaimana data dikirim ke Function Module, bagaimana hasil dikembalikan, dan apakah suatu data dapat diubah selama proses berlangsung.

---

## Tujuan

Parameter Passing digunakan untuk menghubungkan Program dengan Function Module.

Melalui parameter inilah sebuah Function Module mengetahui data apa yang harus diproses dan hasil apa yang harus dikembalikan.

Secara umum hubungan tersebut dapat digambarkan sebagai berikut.

```text
Program

        │

        ▼

CALL FUNCTION

        │

        ▼

Function Module

        │

        ▼

Hasil dikembalikan ke Program
```

---

## Jenis Parameter

ABAP mengenal beberapa jenis parameter pada Function Module.

| Parameter | Fungsi |
|-----------|--------|
| EXPORTING | Mengirim data menuju Function Module |
| IMPORTING | Mengembalikan hasil dari Function Module |
| CHANGING | Data dikirim ke Function Module dan dapat diubah |
| TABLES | Mengirim Internal Table |

Masing-masing memiliki tujuan yang berbeda.

---

# EXPORTING

## Tujuan

`EXPORTING` digunakan untuk mengirim data dari program menuju Function Module.

Program menentukan data yang akan diproses, kemudian Function Module menggunakan data tersebut sebagai input.

---

## Alur

```text
Program

        │

        ▼

EXPORTING

        │

        ▼

Function Module
```

---

## Contoh

```abap
CALL FUNCTION 'Z_CREATE_NOTIFICATION'

    EXPORTING

        iv_equnr = ls_motor-equnr.
```

Artinya.

Program mengirim nilai `ls_motor-equnr` ke parameter `iv_equnr` milik Function Module.

Misalnya.

```
ls_motor-equnr

↓

MTR001
```

Maka di dalam Function Module.

```
iv_equnr

↓

MTR001
```

---

## Kapan Digunakan

Contoh data yang umum dikirim menggunakan `EXPORTING`.

- Equipment Number
- Functional Location
- Notification Number
- Work Order Number
- Username
- Plant
- Voltage

---

# IMPORTING

## Tujuan

`IMPORTING` digunakan untuk menerima hasil pemrosesan dari Function Module.

Program meminta Function Module melakukan suatu pekerjaan, kemudian menerima hasilnya setelah proses selesai.

---

## Alur

```text
Function Module

        │

        ▼

IMPORTING

        │

        ▼

Program
```

---

## Contoh

```abap
CALL FUNCTION 'Z_CREATE_NOTIFICATION'

    IMPORTING

        ev_notification = lv_notification.
```

Misalkan Function Module berhasil membuat Notification.

```
Notification Number

↓

100125
```

Nilai tersebut dikembalikan ke variabel.

```
lv_notification
```

Program kemudian dapat menggunakan Notification Number tersebut untuk proses berikutnya.

---

## Kapan Digunakan

Contoh hasil yang sering dikembalikan.

- Notification Number
- Work Order Number
- Status
- Return Code
- Error Message

---

# CHANGING

## Tujuan

`CHANGING` digunakan apabila Function Module diperbolehkan mengubah nilai parameter yang dikirim oleh program.

Dengan kata lain.

Program mengirim suatu nilai.

Function Module memproses nilai tersebut.

Kemudian hasil perubahan dikembalikan ke variabel yang sama.

---

## Alur

```text
Program

↓

CHANGING

↓

Function Module

↓

CHANGING

↓

Program
```

---

## Contoh

```abap
CALL FUNCTION 'Z_UPDATE_RUNNING_HOUR'

    CHANGING

        cv_running_hour = lv_running_hour.
```

Misalnya.

Sebelum Function Module.

```
lv_running_hour = 5200
```

Di dalam Function Module.

```
5200

↓

5300
```

Setelah Function Module selesai.

```
lv_running_hour = 5300
```

---

## Kapan Digunakan

`CHANGING` digunakan apabila Function Module memang bertugas memperbarui nilai suatu variabel.

---

# TABLES

## Tujuan

`TABLES` digunakan untuk mengirim Internal Table menuju Function Module.

Biasanya digunakan apabila Function Module harus memproses banyak record sekaligus.

---

## Contoh

```abap
CALL FUNCTION 'Z_CHECK_NOTIFICATION'

    TABLES

        it_notification = lt_notification.
```

Pada contoh tersebut.

Seluruh isi `lt_notification` dikirim menuju Function Module.

Function Module kemudian dapat melakukan proses terhadap seluruh record tersebut.

---

## Kapan Digunakan

Contoh penggunaan.

- Daftar Equipment.
- Daftar Notification.
- Daftar Work Order.
- Daftar Error.
- Daftar History.

---

## Ringkasan Perbandingan

| Parameter | Arah Data | Umumnya Digunakan Untuk |
|-----------|-----------|-------------------------|
| EXPORTING | Program → Function Module | Input |
| IMPORTING | Function Module → Program | Output |
| CHANGING | Dua arah | Memperbarui nilai |
| TABLES | Program → Function Module | Internal Table |

---

## Contoh Lengkap

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

- Program mengirim Equipment Number dan Username.
- Function Module membuat Notification.
- Nomor Notification dikembalikan ke program.
- Daftar pesan proses dikembalikan melalui Internal Table.

---

## Praktik yang Umum Digunakan

Pada pengembangan SAP PM, pola berikut sering dijumpai.

```text
Program

↓

Mengirim Equipment Number

↓

Function Module

↓

Melakukan Business Logic

↓

Mengembalikan Notification Number

↓

Program melanjutkan proses berikutnya
```

Business Logic tetap berada di dalam Function Module, sedangkan Program hanya bertugas mengirim data dan menerima hasil.

---

## Ringkasan

- Parameter Passing merupakan mekanisme pertukaran data antara Program dan Function Module.
- `EXPORTING` digunakan untuk mengirim input.
- `IMPORTING` digunakan untuk menerima output.
- `CHANGING` digunakan apabila suatu variabel dapat diperbarui oleh Function Module.
- `TABLES` digunakan untuk mengirim Internal Table.
- Memahami arah aliran data pada setiap parameter lebih penting daripada menghafal sintaksnya.