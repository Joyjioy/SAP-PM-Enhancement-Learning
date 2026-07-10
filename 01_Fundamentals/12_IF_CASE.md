# IF dan CASE

## Latar Belakang

Program ABAP tidak hanya membaca dan menyimpan data. Sebagian besar program bertugas mengambil keputusan berdasarkan data yang sedang diproses.

Sebagai contoh.

- Apakah Equipment mengalami TRIP?
- Apakah Running Hour melebihi batas maintenance?
- Apakah Notification sudah pernah dibuat?
- Apakah Permit masih berlaku?

Keputusan-keputusan tersebut merupakan implementasi dari business rule yang ditentukan oleh proses bisnis SAP.

ABAP menyediakan dua struktur utama untuk pengambilan keputusan, yaitu `IF` dan `CASE`.

---

# Tujuan

Statement `IF` dan `CASE` digunakan untuk mengendalikan alur program berdasarkan kondisi tertentu.

Statement ini menjadi tempat utama implementasi business rule pada program ABAP.

---

# Hubungan dengan Konsep Sebelumnya

Alur program ABAP yang umum adalah sebagai berikut.

```text
SELECT

↓

Internal Table

↓

LOOP

↓

IF / CASE

↓

Business Logic

↓

PERFORM / CALL FUNCTION
```

Pada sebagian besar source code SAP, `IF` atau `CASE` berada di dalam `LOOP`, karena setiap record perlu diperiksa sebelum diproses lebih lanjut.

---

# Statement IF

## Tujuan

`IF` digunakan untuk menjalankan suatu blok program apabila kondisi tertentu terpenuhi.

---

## Sintaks Dasar

```abap
IF kondisi.

    ...

ENDIF.
```

Contoh.

```abap
IF ls_motor-status = 'TRIP'.

    WRITE 'Equipment Trip'.

ENDIF.
```

Apabila status Equipment adalah `TRIP`, maka statement `WRITE` akan dijalankan.

---

## IF ELSE

Program juga dapat menentukan tindakan apabila kondisi tidak terpenuhi.

```abap
IF ls_motor-status = 'TRIP'.

    WRITE 'Trip'.

ELSE.

    WRITE 'Normal'.

ENDIF.
```

---

## ELSEIF

Digunakan apabila terdapat lebih dari satu kondisi.

```abap
IF ls_motor-status = 'TRIP'.

    WRITE 'Trip'.

ELSEIF ls_motor-status = 'RUNNING'.

    WRITE 'Running'.

ELSE.

    WRITE 'Unknown'.

ENDIF.
```

Program akan berhenti pada kondisi pertama yang bernilai benar.

---

# Operator Perbandingan

Operator yang paling sering digunakan.

| Operator | Arti |
|----------|------|
| = | Sama dengan |
| <> | Tidak sama dengan |
| > | Lebih besar |
| < | Lebih kecil |
| >= | Lebih besar atau sama dengan |
| <= | Lebih kecil atau sama dengan |

Contoh.

```abap
IF ls_motor-running_hour >= 6000.

    ...

ENDIF.
```

---

# Operator Logika

Beberapa kondisi dapat digabungkan.

## AND

Seluruh kondisi harus bernilai benar.

```abap
IF ls_motor-voltage >= 1000
AND ls_motor-status = 'TRIP'.

ENDIF.
```

---

## OR

Minimal satu kondisi bernilai benar.

```abap
IF ls_motor-status = 'TRIP'
OR ls_motor-status = 'FAULT'.

ENDIF.
```

---

## NOT

Membalik hasil suatu kondisi.

```abap
IF NOT ls_motor-permit IS INITIAL.

ENDIF.
```

---

# Contoh Kasus SAP PM

Business Requirement.

> Motor Medium Voltage yang mengalami TRIP dan memiliki Running Hour lebih dari 6000 jam harus dibuatkan Notification.

Implementasi.

```abap
IF ls_motor-voltage >= 1000
AND ls_motor-status = 'TRIP'
AND ls_motor-running_hour >= 6000.

    PERFORM create_notification.

ENDIF.
```

Pada contoh tersebut.

Program tidak hanya memeriksa satu kondisi, tetapi beberapa kondisi sekaligus.

---

# Nested IF

Suatu `IF` dapat berada di dalam `IF` lainnya.

Contoh.

```abap
IF ls_motor-status = 'TRIP'.

    IF ls_motor-running_hour >= 6000.

        PERFORM create_notification.

    ENDIF.

ENDIF.
```

Struktur ini disebut Nested IF.

Meskipun valid, penggunaan Nested IF yang terlalu banyak dapat membuat program lebih sulit dibaca.

Apabila memungkinkan, gabungkan kondisi menggunakan operator `AND`.

---

# Statement CASE

## Tujuan

`CASE` digunakan ketika satu variabel memiliki beberapa kemungkinan nilai yang berbeda.

---

## Sintaks Dasar

```abap
CASE ls_motor-status.

    WHEN 'RUNNING'.

        ...

    WHEN 'TRIP'.

        ...

    WHEN 'STOP'.

        ...

    WHEN OTHERS.

        ...

ENDCASE.
```

Program akan memilih satu blok sesuai nilai variabel yang diperiksa.

---

# Kapan Menggunakan CASE

`CASE` lebih sesuai apabila keputusan hanya bergantung pada satu variabel.

Contoh.

Status Equipment.

```abap
CASE ls_motor-status.

    WHEN 'RUNNING'.

    WHEN 'TRIP'.

    WHEN 'MAINTENANCE'.

    WHEN OTHERS.

ENDCASE.
```

---

# IF atau CASE?

Gunakan pertanyaan berikut.

**Apakah keputusan bergantung pada beberapa kondisi?**

Ya

↓

Gunakan `IF`

---

**Apakah keputusan hanya bergantung pada satu variabel dengan beberapa kemungkinan nilai?**

Ya

↓

Gunakan `CASE`

---

## Contoh Perbandingan

### IF

```abap
IF ls_motor-voltage >= 1000
AND ls_motor-status = 'TRIP'.

ENDIF.
```

Melibatkan dua field yang berbeda.

---

### CASE

```abap
CASE ls_motor-status.

    WHEN 'RUNNING'.

    WHEN 'TRIP'.

ENDCASE.
```

Hanya memeriksa satu field.

---

# Praktik yang Umum Digunakan

Pada SAP PM, pola berikut sering dijumpai.

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

Business rule berada di dalam `IF`, sedangkan proses bisnis dijalankan menggunakan `READ TABLE` dan `CALL FUNCTION`.

---

# Ringkasan

- `IF` digunakan ketika keputusan bergantung pada satu atau lebih kondisi.
- `CASE` digunakan ketika keputusan hanya bergantung pada satu variabel.
- Operator `AND`, `OR`, dan `NOT` digunakan untuk menggabungkan beberapa kondisi.
- Sebagian besar business rule pada SAP diimplementasikan menggunakan `IF`.
- `CASE` membuat program lebih mudah dibaca apabila suatu variabel memiliki banyak kemungkinan nilai.