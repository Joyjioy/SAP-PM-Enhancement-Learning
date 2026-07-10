REPORT zcase01_create_notification.

TYPES: BEGIN OF ty_equipment,
         equnr         TYPE char10,
         status        TYPE char20,
       END OF ty_equipment.

TYPES: BEGIN OF ty_notification,
         equnr         TYPE char10,
         status        TYPE char20,
       END OF ty_notification.

DATA: lt_equipment    TYPE TABLE OF ty_equipment,
      lt_notification TYPE TABLE OF ty_notification,
      ls_equipment    TYPE ty_equipment,
      ls_notification TYPE ty_notification.

START-OF-SELECTION.

* Ambil data yang diperlukan sebelum menjalankan business rule.
  PERFORM get_data.

* Evaluasi setiap equipment untuk menentukan
* apakah notification baru perlu dibuat.
  PERFORM process_equipment.

FORM get_data.

* Seluruh equipment dibaca karena setiap equipment
* harus diperiksa satu per satu.

  SELECT equnr
         status
    FROM zequipment
    INTO TABLE lt_equipment.

* Hanya notification yang masih aktif yang diperlukan.
* Notification dengan status CLOSED tidak mempengaruhi
* proses pengambilan keputusan.

  SELECT equnr
         status
    FROM znotification
    INTO TABLE lt_notification
    WHERE status = 'OPEN'
       OR status = 'IN_PROCESS'.

ENDFORM.

FORM process_equipment.

  LOOP AT lt_equipment INTO ls_equipment.

* Business rule hanya berlaku untuk equipment
* yang sedang mengalami TRIP.

    IF ls_equipment-status <> 'TRIP'.
      CONTINUE.
    ENDIF.

* Cari apakah equipment sudah memiliki
* notification yang masih aktif.

    READ TABLE lt_notification
         INTO ls_notification
         WITH KEY equnr = ls_equipment-equnr.

* Jika belum ditemukan notification aktif,
* lanjutkan proses pembuatan notification.

    IF sy-subrc <> 0.

      PERFORM create_notification
        USING ls_equipment-equnr.

    ENDIF.

  ENDLOOP.

ENDFORM.

FORM create_notification USING iv_equnr TYPE char10.

* Simulasi proses pembuatan notification.
* Pada implementasi SAP yang sebenarnya,
* bagian ini dapat diganti dengan Function Module,
* BAPI, atau Enhancement sesuai standar perusahaan.

  WRITE: / 'Create Notification :', iv_equnr.

ENDFORM.