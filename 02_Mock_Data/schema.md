# Database Schema

## Entity Relationship

```text
                    employee
                        │
        ┌───────────────┼─────────────────┐
        │               │                 │
        │               │                 │
 CREATED_BY      APPROVED_BY        PLANNER / TECHNICIAN
        │               │                 │
        ▼               ▼                 ▼

notification      permit          workorder
      │                               ▲
      │                               │
      └───────────────┐               │
                      │               │
                      ▼               │
                 history              │
                      ▲               │
                      │               │
                      └──── EQUNR ────┘
                           │
                           ▼
                     equipment
                           │
                           ▼
               functional_location
```

---

## Relasi

### employee → notification

```
employee.USERID

↓

notification.CREATED_BY
```

---

### employee → permit

```
employee.USERID

↓

permit.APPROVED_BY
```

---

### employee → workorder

```
employee.USERID

↓

workorder.PLANNER

workorder.TECHNICIAN
```

---

### equipment → permit

```
equipment.EQUNR

↓

permit.EQUNR
```

---

### equipment → notification

```
equipment.EQUNR

↓

notification.EQUNR
```

---

### equipment → workorder

```
equipment.EQUNR

↓

workorder.EQUNR
```

---

### equipment → history

```
equipment.EQUNR

↓

history.EQUNR
```

---

### notification → workorder

```
notification.NOTIF_NO

↓

workorder.NOTIF_NO
```

---

### equipment → functional_location

```
equipment.FUNC_LOC

↓

functional_location.FUNC_LOC
```