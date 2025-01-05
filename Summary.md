# Step by step
## Membuat Database Agen Telur (`DB`)
```sql
CREATE DATABASE agen_telur;
```
// ini format gambarnya
 ![alt text](/Folder/nama-gambar.png) 

 ## Membuat Tabel Seller (`Seller`)
 ```sql
 CREATE TABLE seller (
    id_shifter VARCHAR(10) PRIMARY KEY,
    nama_shifter VARCHAR(30) NOT NULL,
    no_telp VARCHAR(20) NOT NULL
) ENGINE=INNODB;
```
// ini format gambarnya
 ![alt text](/Folder/nama-gambar.png) 
