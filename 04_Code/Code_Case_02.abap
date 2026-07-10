REPORT zcase02_prevent_duplicate_notification.

TYPES: BEGIN OF ty_equipment,
         equnr  TYPE char10,
         status TYPE char20,
       END OF ty_equipment.

TYPES: BEGIN OF ty_notification,
         equnr  TYPE char10,
         status TYPE char20,
       END OF ty_notification.

DATA: lt_equipment    TYPE TABLE OF ty_equipment,
      lt_notification TYPE TABLE OF ty_notification,
      ls_equipment    TYPE ty_equipment,
      ls_notification TYPE ty_notification.

START-OF-SELECTION.

* Ambil data yang diperlukan untuk proses validasi.
  PERFORM get_data.

* Jalankan business rule pada setiap equipment.
  PERFORM process_equipment.

FORM get_data.

* Ambil seluruh equipment yang akan dievaluasi.

  SELECT equnr
         status
    FROM zequipment
    INTO TABLE lt_equipment.

* Hanya notification yang masih aktif
* yang diperlukan pada proses validasi.

  SELECT equnr
         status
    FROM znotification
    INTO TABLE lt_notification
    WHERE status = 'OPEN'
       OR status = 'IN_PROCESS'.

ENDFORM.

FORM process_equipment.

  LOOP AT lt_equipment INTO ls_equipment.

* Business rule hanya berlaku untuk
* equipment yang sedang mengalami TRIP.

    IF ls_equipment-status <> 'TRIP'.
      CONTINUE.
    ENDIF.

* Cari apakah equipment sudah memiliki
* notification yang masih aktif.

    READ TABLE lt_notification
         INTO ls_notification
         WITH KEY equnr = ls_equipment-equnr.

* Jika notification aktif ditemukan,
* proses dihentikan untuk equipment ini.

    IF sy-subrc = 0.

      WRITE: / 'Skip - Active Notification Exists :',
               ls_equipment-equnr.

      CONTINUE.

    ENDIF.

* Equipment belum memiliki notification aktif,
* sehingga notification baru dapat dibuat.

    PERFORM create_notification
      USING ls_equipment-equnr.

  ENDLOOP.

ENDFORM.

FORM create_notification USING iv_equnr TYPE char10.

* Simulasi pembuatan notification.
* Pada implementasi SAP yang sebenarnya,
* bagian ini dapat diganti dengan Function Module,
* BAPI, atau Enhancement sesuai standar perusahaan.

  WRITE: / 'Create Notification :', iv_equnr.

ENDFORM.