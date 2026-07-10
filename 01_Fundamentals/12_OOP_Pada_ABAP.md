# Object-Oriented Programming (OOP) pada ABAP

## Latar Belakang

ABAP generasi awal menggunakan pendekatan prosedural (procedural programming). Struktur program dibangun menggunakan `FORM`, `PERFORM`, dan Function Module. Pendekatan tersebut masih banyak dijumpai pada sistem SAP yang telah lama digunakan.

Seiring bertambahnya ukuran sistem dan kompleksitas proses bisnis, pendekatan prosedural mulai memiliki beberapa keterbatasan.

- Data dan logika program tersebar pada banyak subroutine.
- Sulit mengetahui fungsi yang bertanggung jawab terhadap suatu objek bisnis.
- Sulit digunakan kembali pada program lain.
- Pemeliharaan program menjadi lebih kompleks.

Untuk mengatasi permasalahan tersebut, SAP memperkenalkan **ABAP Objects**, yaitu implementasi paradigma Object-Oriented Programming (OOP) pada ABAP.

Pada sistem SAP modern, sebagian besar pengembangan baru menggunakan OOP.

---

# Tujuan

Object-Oriented Programming mengelompokkan data dan operasi yang berkaitan ke dalam satu objek.

Sebagai contoh.

Equipment memiliki:

- Equipment Number
- Voltage
- Status
- Running Hour

Selain memiliki data, Equipment juga memiliki perilaku.

- Check Status
- Create Notification
- Save
- Update Running Hour

Pada OOP, seluruh data dan operasi tersebut ditempatkan di dalam satu Class.

---

# Konsep Dasar

OOP pada ABAP dibangun menggunakan tiga komponen utama.

- Class
- Object
- Method

Hubungan ketiganya.

```text
Class

↓

CREATE OBJECT

↓

Object

↓

Method

↓

Business Logic
```

---

# Class

## Definisi

Class merupakan blueprint yang mendefinisikan struktur sebuah objek.

Di dalam Class biasanya terdapat.

- Attribute (data)
- Method (fungsi)

Class belum dapat digunakan secara langsung.

Program harus membuat Object terlebih dahulu.

---

## Contoh

Misalkan terdapat Class.

```
ZCL_MOTOR
```

Class tersebut dapat memiliki.

### Attribute

- Equipment Number
- Voltage
- Running Hour
- Status

### Method

- CHECK_STATUS
- CREATE_NOTIFICATION
- UPDATE_RUNNING_HOUR
- SAVE

---

# Struktur Class

Sebuah Class pada ABAP umumnya memiliki dua bagian.

```abap
CLASS zcl_motor DEFINITION.

ENDCLASS.

CLASS zcl_motor IMPLEMENTATION.

ENDCLASS.
```

Masing-masing memiliki fungsi yang berbeda.

---

## CLASS DEFINITION

Bagian ini mendefinisikan isi Class.

Misalnya.

- Attribute
- Method
- Visibility

Bagian ini belum berisi implementasi program.

Contoh.

```abap
CLASS zcl_motor DEFINITION.

    PUBLIC SECTION.

        METHODS check_status.

ENDCLASS.
```

Program hanya mengetahui bahwa Class memiliki Method bernama `check_status`.

Bagaimana Method tersebut bekerja belum dijelaskan.

---

## CLASS IMPLEMENTATION

Bagian ini berisi implementasi seluruh Method.

Contoh.

```abap
CLASS zcl_motor IMPLEMENTATION.

    METHOD check_status.

        ...

    ENDMETHOD.

ENDCLASS.
```

Seluruh business logic ditulis pada bagian ini.

---

# Visibility

Attribute maupun Method dapat memiliki tingkat akses yang berbeda.

Yang paling umum digunakan adalah.

## PUBLIC SECTION

Komponen yang dapat diakses dari luar Class.

Misalnya.

```abap
PUBLIC SECTION.

    METHODS save.
```

Program lain dapat memanggil.

```abap
lo_motor->save( ).
```

---

## PRIVATE SECTION

Komponen yang hanya dapat digunakan oleh Class itu sendiri.

Program lain tidak dapat mengaksesnya secara langsung.

Biasanya digunakan untuk menyimpan helper method maupun data internal.

---

# Attribute

Attribute merupakan data yang dimiliki oleh Object.

Contoh.

```text
Equipment Number

Voltage

Running Hour

Status
```

Setiap Object memiliki nilai Attribute yang berbeda.

Misalnya.

| Object | Equipment | Status |
|----------|-----------|---------|
| lo_motor_1 | MTR001 | TRIP |
| lo_motor_2 | MTR002 | RUNNING |

---

# Method

Method merupakan fungsi yang dimiliki oleh sebuah Class.

Method bekerja terhadap Attribute milik Object.

Contoh.

```abap
METHOD check_status.

ENDMETHOD.
```

Method tidak berdiri sendiri.

Method selalu dimiliki oleh suatu Class.

---

# Object

## Definisi

Object merupakan instance dari sebuah Class.

Program membuat Object ketika ingin menggunakan Class.

Contoh.

```abap
DATA lo_motor TYPE REF TO zcl_motor.

CREATE OBJECT lo_motor.
```

Setelah Object berhasil dibuat, seluruh Method pada Class dapat digunakan.

---

# Memanggil Method

Method dipanggil menggunakan operator `->`.

Contoh.

```abap
lo_motor->check_status( ).

lo_motor->save( ).
```

Operator `->` menunjukkan bahwa Method tersebut dijalankan oleh Object `lo_motor`.

---

# Constructor

Constructor merupakan Method yang dijalankan secara otomatis ketika Object dibuat.

Pada ABAP, Constructor ditulis menggunakan Method.

```abap
CONSTRUCTOR
```

Biasanya digunakan untuk.

- Inisialisasi nilai awal.
- Membaca konfigurasi.
- Menyiapkan Object sebelum digunakan.

---

# Static Method dan Instance Method

Secara umum terdapat dua jenis Method.

## Instance Method

Harus dipanggil melalui Object.

```abap
lo_motor->check_status( ).
```

Method bekerja terhadap data milik Object tersebut.

---

## Static Method

Tidak memerlukan Object.

Dipanggil menggunakan nama Class.

```abap
zcl_motor=>get_default_voltage( ).
```

Static Method biasanya digunakan untuk fungsi yang tidak bergantung pada data suatu Object.

---

# Hubungan OOP dengan Function Module

Keduanya sama-sama digunakan untuk menjalankan suatu proses.

Perbedaannya terletak pada cara pengorganisasian program.

| Function Module | OOP |
|-----------------|-----|
| Berorientasi fungsi | Berorientasi objek |
| Data dikirim melalui parameter | Data menjadi bagian dari Object |
| Tidak menyimpan state | Object dapat menyimpan state selama program berjalan |

Pada ABAP modern, banyak Function Module lama mulai digantikan oleh Class.

---

# Hubungan OOP dengan SAP PM

Pada SAP PM, sebuah Class umumnya merepresentasikan objek bisnis.

Contoh.

| Business Object | Contoh Class |
|-----------------|--------------|
| Equipment | ZCL_EQUIPMENT |
| Motor | ZCL_MOTOR |
| Notification | ZCL_NOTIFICATION |
| Work Order | ZCL_WORKORDER |

Setiap Class bertanggung jawab terhadap proses bisnis yang berkaitan dengan objek tersebut.

---

# Alur Eksekusi Program OOP

Contoh sederhana.

```abap
DATA lo_motor TYPE REF TO zcl_motor.

CREATE OBJECT lo_motor.

lo_motor->set_equipment( 'MTR001' ).

lo_motor->check_status( ).

lo_motor->create_notification( ).

lo_motor->save( ).
```

Urutan proses.

```text
Program

↓

CREATE OBJECT

↓

Object terbentuk

↓

Set Equipment

↓

Check Status

↓

Create Notification

↓

Save
```

Program utama hanya mengatur urutan proses.

Seluruh business logic berada pada Method di dalam Class.

---

# Ringkasan

- OOP merupakan paradigma utama pada pengembangan ABAP modern.
- Class mendefinisikan data dan Method.
- Object merupakan instance dari sebuah Class.
- Method merupakan fungsi yang dimiliki oleh Class.
- `CLASS DEFINITION` digunakan untuk mendefinisikan struktur Class.
- `CLASS IMPLEMENTATION` digunakan untuk menuliskan implementasi Method.
- Method dipanggil menggunakan operator `->`.
- OOP mengelompokkan data dan business logic berdasarkan objek bisnis sehingga struktur program lebih mudah dipelihara dan dikembangkan.