# attendence
A simple way to keep track of who attends your events.

## Facts or so:
 - backend: Supabase
 - frontend: Dart (Flutter)
 - intended platform: Mobile (Android)

## Overview:

groups:
<br> <img src="./documentation/pictures/overview.jpg" alt="group overview" width="200"/>

people & dates table:
<br> <img src="./documentation/pictures/table.jpg" alt="table overview" width="200"/>

people overview:
<br> <img src="./documentation/pictures/people.jpg" alt="people overview" width="200"/>

person edit attendance:
<br> <img src="./documentation/pictures/person_edit.jpg" alt="person overview" width="200"/>

dates:
<br> <img src="./documentation/pictures/dates.jpg" alt="dates overview" width="200"/>

date edit attendance:
<br> <img src="./documentation/pictures/date_edit.jpg" alt="dates overview" width="200"/>


## Setup:
1. create Supabase Project
2. put URL & Key in .env file (example: .env.example)
3. create database table
```sql
CREATE TABLE attendenceData (
    id bigint NOT NULL PRIMARY KEY,
    created_at timestamp with time zone DEFAULT now(),
    name text,
    passwd text,
    data json DEFAULT '{"dates":[],"people":[]}'::json
);
```
4. compile
```console
flutter pub get && flutter build apk --release
```
5. install
