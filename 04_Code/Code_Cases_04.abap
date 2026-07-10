REPORT zcase04_permit_validation.

TYPES: BEGIN OF ty_equipment,
         equnr         TYPE char10,
         status        TYPE char20,
         running_hour  TYPE i,
       END OF ty_equipment.

TYPES: BEGIN OF ty_notification,
         equnr         TYPE char10,
         status        TYPE char20,
       END OF ty_notification.

TYPES: BEGIN OF ty_permit,
         equnr          TYPE char10,
         permit_status  TYPE char20,
       END OF ty_permit.

DATA: lt_equipment    TYPE TABLE OF ty_equipment,
      lt_notification TYPE TABLE OF ty_notification,
      lt_permit       TYPE TABLE OF ty_permit,
      ls_equipment    TYPE ty_equipment,
      ls_notification TYPE ty_notification,
      ls_permit       TYPE ty_permit.

START-OF-SELECTION.

* Ambil seluruh data yang diperlukan untuk proses validasi.
  PERFORM get_data.

* Jalankan business rule terbaru.
  PERFORM process_equipment.

FORM get_data.

  SELECT equnr
         status
         running_hour
    FROM zequipment
    INTO TABLE lt_equipment.

  SELECT equnr
         status
    FROM znotification
    INTO TABLE lt_notification
    WHERE status = 'OPEN'
       OR status = 'IN_PROCESS'.

  SELECT equnr
         permit_status
    FROM zpermit
    INTO TABLE lt_permit.

ENDFORM.

FORM process_equipment.

  LOOP AT lt_equipment INTO ls_equipment.

* Business rule hanya berlaku untuk equipment TRIP.

    IF ls_equipment-status <> 'TRIP'.
      CONTINUE.
    ENDIF.

* Equipment harus melewati batas running hour.

    IF ls_equipment-running_hour <= 6000.
      CONTINUE.
    ENDIF.

* Notification aktif tidak boleh sudah ada.

    READ TABLE lt_notification
         INTO ls_notification
         WITH KEY equnr = ls_equipment-equnr.

    IF sy-subrc = 0.
      CONTINUE.
    ENDIF.

* Periksa status permit.

    READ TABLE lt_permit
         INTO ls_permit
         WITH KEY equnr = ls_equipment-equnr.

    IF sy-subrc <> 0.

      MESSAGE 'Permit data not found.' TYPE 'E'.
      EXIT.

    ENDIF.

    IF ls_permit-permit_status <> 'APPROVED'.

      MESSAGE 'Permit is not approved.' TYPE 'E'.
      EXIT.

    ENDIF.

* Seluruh business rule telah terpenuhi.

    PERFORM create_notification
      USING ls_equipment-equnr.

  ENDLOOP.

ENDFORM.

FORM create_notification USING iv_equnr TYPE char10.

* Simulasi proses pembuatan Notification.
* Pada sistem SAP sebenarnya bagian ini dapat
* diganti dengan Function Module atau BAPI.

  WRITE: / 'Create Notification :', iv_equnr.

ENDFORM.