import mysql.connector

class DataAccessLayer:
    def __init__(self):
        self.config = {
            'host': 'localhost',
            'user': 'root',
            'password': 'UyanYigit742004',  # <--- MySQL şifreni buraya yaz (şifre yoksa boş bırak)
            'database': 'ZiraiIlacSistem' 
        }

    def musteriler_hepsi(self):
        conn = mysql.connector.connect(**self.config)
        cursor = conn.cursor(dictionary=True)
        
        cursor.callproc('MusterilerHepsi')
        
        sonuclar = []
        for result in cursor.stored_results():
            sonuclar.extend(result.fetchall())
            
        cursor.close()
        conn.close()
        return sonuclar

    def musteri_ekle(self, ad, tc, tel):
        conn = mysql.connector.connect(**self.config)
        cursor = conn.cursor()
        
        cursor.callproc('MusteriEkle', (ad, tc, tel))
        
        conn.commit()
        cursor.close()
        conn.close()

    def musteri_sil(self, id):
        conn = mysql.connector.connect(**self.config)
        cursor = conn.cursor()
        
        # Sadece ID parametresi göndererek silme prosedürünü tetikliyoruz
        cursor.callproc('MusteriSil', (id,))
        
        conn.commit()
        cursor.close()
        conn.close()

    
    def musteri_guncelle(self, id, ad, tc, tel):
        conn = mysql.connector.connect(**self.config)
        cursor = conn.cursor()
        
        # Güncelleme prosedürünü parametreleriyle çağırıyoruz
        cursor.callproc('MusteriGuncelle', (id, ad, tc, tel))
        
        conn.commit()
        cursor.close()
        conn.close()



    def urunleri_getir(self):
        conn = mysql.connector.connect(**self.config)
        cursor = conn.cursor(dictionary=True)
        cursor.callproc('UrunleriListele')
        sonuclar = [res.fetchall() for res in cursor.stored_results()]
        cursor.close()
        conn.close()
        return sonuclar[0] if sonuclar else []

    def stok_getir(self, urun_id):
        conn = mysql.connector.connect(**self.config)
        cursor = conn.cursor(dictionary=True)
        cursor.callproc('UrunStokGetir', (urun_id,))
        stok = 0
        for res in cursor.stored_results():
            row = res.fetchone()
            if row: stok = row['Stok']
        cursor.close()
        conn.close()
        return stok

    def sepeti_getir(self, musteri_id):
        conn = mysql.connector.connect(**self.config)
        cursor = conn.cursor(dictionary=True)
        cursor.callproc('SepetiGetir', (musteri_id,))
        sonuclar = [res.fetchall() for res in cursor.stored_results()]
        cursor.close()
        conn.close()
        return sonuclar[0] if sonuclar else []

    def sepete_ekle(self, musteri_id, urun_id, miktar):
        conn = mysql.connector.connect(**self.config)
        cursor = conn.cursor()
        cursor.callproc('SepeteEkle', (musteri_id, urun_id, miktar))
        conn.commit()
        cursor.close()
        conn.close()

    def sepetten_sil(self, sepet_id):
        conn = mysql.connector.connect(**self.config)
        cursor = conn.cursor()
        cursor.callproc('SepettenSil', (sepet_id,))
        conn.commit()
        cursor.close()
        conn.close()