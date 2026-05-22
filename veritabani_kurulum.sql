create database ZiraiIlacSistem;
use ZiraiIlacSistem;

-- 2. KATEGORİLER Tablosu (Bağımsız Tablo)
CREATE TABLE Kategoriler (
    Kategori_ID INT AUTO_INCREMENT PRIMARY KEY,
    Kategori_Adi VARCHAR(100) NOT NULL,
    Aciklama VARCHAR(250)
);

-- 3. TEDARİKÇİLER Tablosu (Bağımsız Tablo)
CREATE TABLE Tedarikciler (
    Tedarikci_ID INT AUTO_INCREMENT PRIMARY KEY,
    Firma_Adi VARCHAR(150) NOT NULL,
    Telefon VARCHAR(15),
    Adres TEXT
);

-- 4. MÜŞTERİLER Tablosu (Bağımsız Tablo)
CREATE TABLE Musteriler (
    Musteri_ID INT AUTO_INCREMENT PRIMARY KEY,
    Ad_Soyad VARCHAR(100) NOT NULL,
    TC_No CHAR(11) UNIQUE NOT NULL,
    Telefon VARCHAR(15)
);

-- 5. ÜRÜNLER Tablosu (Kategori ve Tedarikçi'ye Bağımlı)
CREATE TABLE Urunler (
    Urun_ID INT AUTO_INCREMENT PRIMARY KEY,
    Urun_Adi VARCHAR(150) NOT NULL,
    Kategori_ID INT,
    Tedarikci_ID INT,
    Birim_Fiyat DECIMAL(10,2) NOT NULL,
    Stok_Miktari INT NOT NULL DEFAULT 0,
    Son_Kullanma_Tarihi DATE NOT NULL
    );
    
    -- 6. SATIŞLAR Tablosu (Müşteri'ye Bağımlı)
CREATE TABLE Satislar (
    Satis_ID INT AUTO_INCREMENT PRIMARY KEY,
    Musteri_ID INT,
    Satis_Tarihi DATETIME DEFAULT CURRENT_TIMESTAMP, -- Otomatik o anki tarihi atar
    Toplam_Tutar DECIMAL(10,2) DEFAULT 0,
    
    -- Foreign Key Bağlantısı
    FOREIGN KEY (Musteri_ID) REFERENCES Musteriler(Musteri_ID)
);

-- 7. SATIŞ DETAY Tablosu (Satışlar ve Ürünler'e Bağımlı)
CREATE TABLE Satis_Detay (
    Satis_Detay_ID INT AUTO_INCREMENT PRIMARY KEY,
    Satis_ID INT,
    Urun_ID INT,
    Miktar INT NOT NULL,
    
    -- Foreign Key Bağlantıları
    FOREIGN KEY (Satis_ID) REFERENCES Satislar(Satis_ID),
    FOREIGN KEY (Urun_ID) REFERENCES Urunler(Urun_ID)
);


--urunler icin delimiter uygulamasi
DELIMITER $$
CREATE PROCEDURE UrunlerHepsi ()
BEGIN
    SELECT * FROM Urunler;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE UrunEkle (
    ad      varchar(150),
    kid     int,
    tid     int,
    fiyat   decimal(10,2),
    stok    int,
    skt     date
)
BEGIN
    INSERT INTO Urunler (Urun_Adi, Kategori_ID, Tedarikci_ID, Birim_Fiyat, Stok_Miktari, Son_Kullanma_Tarihi)
    VALUES  (ad, kid, tid, fiyat, stok, skt);
END $$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE UrunGuncelle (
    id      int,
    ad      varchar(150),
    kid     int,
    tid     int,
    fiyat   decimal(10,2),
    stok    int,
    skt     date
)
BEGIN
    UPDATE Urunler
    SET
        Urun_Adi            = ad,
        Kategori_ID         = kid,
        Tedarikci_ID        = tid,
        Birim_Fiyat         = fiyat,
        Stok_Miktari        = stok,
        Son_Kullanma_Tarihi = skt
    WHERE
        Urun_ID             = id;
END $$
DELIMITER ; 


DELIMITER $$
CREATE PROCEDURE UrunSil (
    id      int
)
BEGIN
    DELETE FROM Urunler
    WHERE Urun_ID  = id;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE UrunBul (
    filtre  varchar(32)
)
BEGIN
    SELECT * FROM Urunler
    WHERE
        Urun_Adi    LIKE  CONCAT('%',filtre,'%');
END $$
DELIMITER ;


--kategoriler icin delimiter uygulamasi

DELIMITER $$
CREATE PROCEDURE KategorilerHepsi ()
BEGIN
    SELECT
        Kategori_ID   as ID,
        Kategori_Adi  as `Kategori Adı`,
        Aciklama      as `Açıklama`
    FROM Kategoriler;
END $$
DELIMITER ;
--KATEGORILERI GORUNTULE
DELIMITER $$
CREATE PROCEDURE KategoriEkle (
    ad      varchar(100),
    ack     varchar(250)
)
BEGIN
    INSERT INTO Kategoriler (Kategori_Adi, Aciklama)
    VALUES  (ad, ack);
END $$
DELIMITER ;

--KATEGORI EKLE 
DELIMITER $$
CREATE PROCEDURE KategoriEkle (
    ad      varchar(100),
    ack     varchar(250)
)
BEGIN
    INSERT INTO Kategoriler (Kategori_Adi, Aciklama)
    VALUES  (ad, ack);
END $$
DELIMITER ;
--KATEGORI GUNCELLE
DELIMITER $$
CREATE PROCEDURE KategoriGuncelle (
    id      int,
    ad      varchar(100),
    ack     varchar(250)
)
BEGIN
    UPDATE Kategoriler
    SET
        Kategori_Adi  = ad,
        Aciklama      = ack
    WHERE
        Kategori_ID   = id;
END $$
DELIMITER ;
--KATEGORI SIL
DELIMITER $$
CREATE PROCEDURE KategoriSil (
    id      int
)
BEGIN
    DELETE FROM Kategoriler
    WHERE   Kategori_ID  = id;
END $$
DELIMITER ;
--KATEGORILERI LISTELE
DELIMITER $$
CREATE PROCEDURE KategoriBul (
    filtre  varchar(32)
)
BEGIN
    SELECT * FROM Kategoriler
    WHERE
        Kategori_Adi  LIKE  CONCAT('%',filtre,'%') OR
        Aciklama      LIKE  CONCAT('%',filtre,'%');
END $$
DELIMITER ;

-----------------TEDARIKCILER ICIN DELIMITER UYGULAMALARI

--TEDARIKCILERI LISTELE 
DELIMITER $$
CREATE PROCEDURE TedarikcilerHepsi ()
BEGIN
    SELECT
        Tedarikci_ID  as ID,
        Firma_Adi     as `Firma Adı`,
        Telefon       as Telefon,
        Adres         as Adres
    FROM Tedarikciler;
END $$
DELIMITER ;

--TEDARIKCILERI EKLE
DELIMITER $$
CREATE PROCEDURE TedarikciEkle (
    ad      varchar(150),
    tel     varchar(15),
    adr     text
)
BEGIN
    INSERT INTO Tedarikciler (Firma_Adi, Telefon, Adres)
    VALUES  (ad, tel, adr);
END $$
DELIMITER ;

--TEDARIKCILERI GUNCELLE
DELIMITER $$
CREATE PROCEDURE TedarikciGuncelle (
    id      int,
    ad      varchar(150),
    tel     varchar(15),
    adr     text
)
BEGIN
    UPDATE Tedarikciler
    SET
        Firma_Adi   = ad,
        Telefon     = tel,
        Adres       = adr
    WHERE
        Tedarikci_ID = id;
END $$
DELIMITER ;

--TEDERIKCI SIL
DELIMITER $$
CREATE PROCEDURE TedarikciSil (
    id      int
)
BEGIN
    DELETE FROM Tedarikciler
    WHERE   Tedarikci_ID = id;
END $$
DELIMITER ;

--TEDARIKCI LISTELE
DELIMITER $$
CREATE PROCEDURE TedarikciBul (
    filtre  varchar(32)
)
BEGIN
    SELECT * FROM Tedarikciler
    WHERE
        Firma_Adi   LIKE  CONCAT('%',filtre,'%') OR
        Telefon     LIKE  CONCAT('%',filtre,'%') OR
        Adres       LIKE  CONCAT('%',filtre,'%');
END $$
DELIMITER ;

--------SATISLAR ICIN DELIMITTER UYGULAMALARI
--SATISLAR HEPSI
DELIMITER $$
CREATE PROCEDURE SatislarHepsi ()
BEGIN
    SELECT
        s.Satis_ID      as ID,
        m.Ad_Soyad      as `Müşteri Ad Soyad`,
        s.Satis_Tarihi  as `Satış Tarihi`,
        s.Toplam_Tutar  as `Toplam Tutar`
    FROM Satislar s
    INNER JOIN Musteriler m ON s.Musteri_ID = m.Musteri_ID;
END $$
DELIMITER ;

--SATIS EKLE
DELIMITER $$
CREATE PROCEDURE SatisEkle (
    mid     int,
    tarih   datetime,
    tutar   decimal(10,2)
)
BEGIN
    INSERT INTO Satislar (Musteri_ID, Satis_Tarihi, Toplam_Tutar)
    VALUES  (mid, tarih, tutar);
END $$
DELIMITER ;
--SATIS GUNCELLE
DELIMITER $$
CREATE PROCEDURE SatisGuncelle (
    id      int,
    mid     int,
    tarih   datetime,
    tutar   decimal(10,2)
)
BEGIN
    UPDATE Satislar
    SET
        Musteri_ID    = mid,
        Satis_Tarihi  = tarih,
        Toplam_Tutar  = tutar
    WHERE
        Satis_ID      = id;
END $$
DELIMITER ;

--SATIS SIL

DELIMITER $$
CREATE PROCEDURE SatisSil (
    id      int
)
BEGIN
    DELETE FROM Satislar
    WHERE   Satis_ID  = id;
END $$
DELIMITER ;

--SATISLARI LISTELE

DELIMITER $$
CREATE PROCEDURE SatisBul (
    filtre  varchar(32)
)
BEGIN
    -- Satışları müşteri adına göre filtreliyoruz
    SELECT 
        s.Satis_ID      as ID,
        m.Ad_Soyad      as `Müşteri Ad Soyad`,
        s.Satis_Tarihi  as `Satış Tarihi`,
        s.Toplam_Tutar  as `Toplam Tutar`
    FROM Satislar s
    INNER JOIN Musteriler m ON s.Musteri_ID = m.Musteri_ID
    WHERE
        m.Ad_Soyad LIKE CONCAT('%',filtre,'%');
END $$
DELIMITER ;


-------------------SATIS DETAY ICIN DELIMITER UYGULAMALARI
--SATIS DETAY HEPSI
DELIMITER $$
CREATE PROCEDURE SatisDetayHepsi ()
BEGIN
    SELECT
        sd.Satis_Detay_ID as ID,
        sd.Satis_ID       as `Fatura No`,
        u.Urun_Adi        as `Zirai İlaç`,
        sd.Miktar         as Miktar
    FROM Satis_Detay sd
    INNER JOIN Urunler u ON sd.Urun_ID = u.Urun_ID;
END $$
DELIMITER ;


--SATIS DETAY EKLE
DELIMITER $$
CREATE PROCEDURE SatisDetayEkle (
    sid     int,
    uid     int,
    mik     int
)
BEGIN
    INSERT INTO Satis_Detay (Satis_ID, Urun_ID, Miktar)
    VALUES  (sid, uid, mik);
END $$
DELIMITER ;

--SATIS DETAY GUNCELLE

DELIMITER $$
CREATE PROCEDURE SatisDetayGuncelle (
    id      int,
    sid     int,
    uid     int,
    mik     int
)
BEGIN
    UPDATE Satis_Detay
    SET
        Satis_ID  = sid,
        Urun_ID   = uid,
        Miktar    = mik
    WHERE
        Satis_Detay_ID = id;
END $$
DELIMITER ;

--SATIS DETAY SIL
DELIMITER $$
CREATE PROCEDURE SatisDetaySil (
    id      int
)
BEGIN
    DELETE FROM Satis_Detay
    WHERE   Satis_Detay_ID = id;
END $$
DELIMITER ;

--SATIS DETAY LISTELEME
DELIMITER $$
CREATE PROCEDURE SatisFaturaDetay ()
BEGIN
    SELECT
        s.Satis_ID as `Fatura No`,
        m.Ad_Soyad as `Çiftçi Ad Soyad`,
        u.Urun_Adi as `Satılan İlaç / Tohum`,
        k.Kategori_Adi as `Kategori`,
        u.Birim_Fiyat as `Birim Fiyat`,
        sd.Miktar as `Miktar`,
        (u.Birim_Fiyat * sd.Miktar) as `Ara Toplam`,
        s.Satis_Tarihi as `Satış Tarihi`
    FROM Musteriler m 
    INNER JOIN Satislar s ON m.Musteri_ID = s.Musteri_ID
    INNER JOIN Satis_Detay sd ON s.Satis_ID = sd.Satis_ID
    INNER JOIN Urunler u ON sd.Urun_ID = u.Urun_ID
    INNER JOIN Kategoriler k ON u.Kategori_ID = k.Kategori_ID;
END $$
DELIMITER ;


-----------------------TRIGGER ILE SINIRLANDIRMA ISLEMLERI 

--STOK KONTROLU
DELIMITER $$
CREATE TRIGGER tg_stok_kontrol
BEFORE INSERT ON Satis_Detay FOR EACH ROW
BEGIN
    DECLARE stk INT;
    DECLARE hatamesaj VARCHAR(250);

    -- Satılmak istenen ürünün güncel stok miktarını bul
    SELECT Stok_Miktari INTO stk
    FROM Urunler 
    WHERE Urun_ID = NEW.Urun_ID;

    -- Eğer istenen miktar stoktan büyükse hata fırlat ve işlemi durdur
    IF (NEW.Miktar > stk) THEN
        SET hatamesaj = CONCAT('HATA: Yeterli stok yok! İstenen: ', NEW.Miktar, ', Mevcut: ', stk);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = hatamesaj;
    END IF;
END $$
DELIMITER ;



--SON KULLANMA TARIHI KONTROLU

DELIMITER $$
CREATE TRIGGER tg_skt_kontrol
BEFORE INSERT ON Satis_Detay FOR EACH ROW
BEGIN
    DECLARE skt_tarihi DATE;
    DECLARE hatamesaj VARCHAR(250);

    -- Ürünün son kullanma tarihini al
    SELECT Son_Kullanma_Tarihi INTO skt_tarihi
    FROM Urunler 
    WHERE Urun_ID = NEW.Urun_ID;

    -- Eğer son kullanma tarihi bugünden (CURDATE) küçükse hata fırlat
    IF (skt_tarihi < CURDATE()) THEN
        SET hatamesaj = 'HATA: Son kullanma tarihi geçmiş zirai ilaç satılamaz!';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = hatamesaj;
    END IF;
END $$
DELIMITER ;


--STOK DUSME TETIKLEYICISI

DELIMITER $$
CREATE TRIGGER tg_stok_azalt
AFTER INSERT ON Satis_Detay FOR EACH ROW
BEGIN
    -- Ürünler tablosundaki stoğu, satılan miktar (NEW.Miktar) kadar azalt
    UPDATE Urunler 
    SET Stok_Miktari = Stok_Miktari - NEW.Miktar
    WHERE Urun_ID = NEW.Urun_ID;
END $$
DELIMITER ;



--BURASI HATA DÜZELTME VE KİŞİ EKLE GÜNCELLE SİL SEPET EKLE KISIMLARININ REVİZE EDİLMESİ KOMUTLARI

USE ZiraiIlacSistem;

-- Eski hatalı prosedürleri temizliyoruz
DROP PROCEDURE IF EXISTS MusterilerHepsi;
DROP PROCEDURE IF EXISTS MusteriEkle;

-- 1. Listeleme Prosedürü (Düzeltilmiş)
DELIMITER $$
CREATE PROCEDURE MusterilerHepsi ()
BEGIN
    SELECT
        Musteri_ID as ID,
        Ad_Soyad as `Ad Soyad`,
        TC_No as TCKN,
        Telefon as Telefon
    FROM Musteriler;
END $$
DELIMITER ;

-- 2. Ekleme Prosedürü (Düzeltilmiş)
DELIMITER $$
CREATE PROCEDURE MusteriEkle (
    ad      varchar(150),
    tc      varchar(11),
    tel     varchar(15)
)
BEGIN
    INSERT INTO Musteriler (Ad_Soyad, TC_No, Telefon)
    VALUES  (ad, tc, tel);
END $$
DELIMITER ;	



USE ZiraiIlacSistem;

DELIMITER $$
CREATE PROCEDURE MusteriSil (
    id INT
)
BEGIN
    DELETE FROM Musteriler
    WHERE Musteri_ID = id;
END $$
DELIMITER ;


USE ZiraiIlacSistem;

DELIMITER $$
CREATE PROCEDURE MusteriGuncelle (
    id      INT,
    ad      varchar(150),
    tc      varchar(11),
    tel     varchar(15)
)
BEGIN
    UPDATE Musteriler
    SET
        Ad_Soyad = ad,
        TC_No = tc,
        Telefon = tel
    WHERE Musteri_ID = id;
END $$
DELIMITER ;


--BURASI URUNLER TABLOSUNA VERİ EKLENMESİ KISIMI 

USE ZiraiIlacSistem;

-- Sende Urunler tablosu zaten olduğu için sadece Sepet tablosunu oluşturuyoruz
CREATE TABLE IF NOT EXISTS Sepet (
    Sepet_ID INT AUTO_INCREMENT PRIMARY KEY,
    Musteri_ID INT,
    Urun_ID INT,
    Miktar INT
);

-- Senin tablonun sütun isimlerine ve zorunlu alanlarına tam uyumlu örnek veri ekleme
INSERT INTO urunler (Urun_Adi, Kategori_ID, Tedarikci_ID, Birim_Fiyat, Stok_Miktari, Son_Kullanma_Tarihi) VALUES 
('Ot İlacı (Herbisit) 5L', 1, 1, 450.00, 20, '2026-12-31'),
('Böcek İlacı (Pestisit) 1L', 1, 1, 200.00, 5, '2026-12-31'),
('Mantar İlacı (Fungisit) 2L', 1, 1, 300.00, 50, '2026-12-31'),
('Sıvı Yaprak Gübresi 10L', 1, 1, 600.00, 15, '2026-12-31');

-- Eski prosedürleri temizleyelim
DROP PROCEDURE IF EXISTS UrunleriListele;
DROP PROCEDURE IF EXISTS UrunStokGetir;
DROP PROCEDURE IF EXISTS SepetiGetir;
DROP PROCEDURE IF EXISTS SepeteEkle;
DROP PROCEDURE IF EXISTS SepettenSil;

-- PROSEDÜRLER (Senin sütun isimlerine göre uyarlandı)
DELIMITER $$
CREATE PROCEDURE UrunleriListele()
BEGIN
    -- Python'un hata vermemesi için Stok_Miktari'nı Stok, Birim_Fiyat'ı Fiyat olarak okutuyoruz
    SELECT Urun_ID, Urun_Adi, Stok_Miktari AS Stok, Birim_Fiyat AS Fiyat FROM urunler;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE UrunStokGetir(p_urun_id INT)
BEGIN
    SELECT Stok_Miktari AS Stok FROM urunler WHERE Urun_ID = p_urun_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE SepetiGetir(p_musteri_id INT)
BEGIN
    SELECT s.Sepet_ID, u.Urun_Adi, s.Miktar, u.Birim_Fiyat AS Fiyat, (s.Miktar * u.Birim_Fiyat) AS Toplam_Tutar 
    FROM Sepet s 
    INNER JOIN urunler u ON s.Urun_ID = u.Urun_ID 
    WHERE s.Musteri_ID = p_musteri_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE SepeteEkle(p_musteri_id INT, p_urun_id INT, p_miktar INT)
BEGIN
    INSERT INTO Sepet (Musteri_ID, Urun_ID, Miktar) VALUES (p_musteri_id, p_urun_id, p_miktar);
    -- Senin Stok_Miktari sütununu güncelliyoruz
    UPDATE urunler SET Stok_Miktari = Stok_Miktari - p_miktar WHERE Urun_ID = p_urun_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE SepettenSil(p_sepet_id INT)
BEGIN
    DECLARE v_urun_id INT;
    DECLARE v_miktar INT;
    SELECT Urun_ID, Miktar INTO v_urun_id, v_miktar FROM Sepet WHERE Sepet_ID = p_sepet_id;
    -- Ürün iptal edilince stokları senin tablona geri ekliyoruz
    UPDATE urunler SET Stok_Miktari = Stok_Miktari + v_miktar WHERE Urun_ID = v_urun_id;
    DELETE FROM Sepet WHERE Sepet_ID = p_sepet_id;
END $$
DELIMITER ;