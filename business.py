from dal import DataAccessLayer

class BusinessLayer:
    def __init__(self):
        self.dal = DataAccessLayer()

    def musteri_listele(self):
        return self.dal.musteriler_hepsi()

    def musteri_kaydet(self, ad, tc, tel):
        if not ad or not tc or not tel:
            return False, "HATA: Tüm alanları doldurmak zorunludur!"
            
        if len(tc) != 11 or not tc.isdigit():
            return False, "HATA: TC Kimlik Numarası 11 haneli ve rakamlardan oluşmalıdır!"
            
        try:
            self.dal.musteri_ekle(ad, tc, tel)
            return True, "Başarılı! Çiftçi kaydı sisteme eklendi."
        except Exception as e:
            return False, f"Veritabanı Hatası: {str(e)}"
        

    def musteri_sil(self, id):
        try:
            self.dal.musteri_sil(id)
            return True, "Çiftçi kaydı başarıyla silindi."
        except Exception as e:
            # Eğer bu müşteriye ait yapılmış bir satış varsa, MySQL silmeye izin vermez (Foreign Key Koruması)
            return False, f"Hata: Bu kişiye ait geçmiş satış kaydı bulunduğu için silinemez!"
        

    def musteri_guncelle(self, id, ad, tc, tel):
        # Tıpkı eklemedeki gibi boş bırakılma ve TC kurallarını burada da kontrol ediyoruz
        if not ad or not tc or not tel:
            return False, "HATA: Tüm alanları doldurmak zorunludur!"
            
        if len(tc) != 11 or not tc.isdigit():
            return False, "HATA: TC Kimlik Numarası 11 haneli ve rakamlardan oluşmalıdır!"
            
        try:
            self.dal.musteri_guncelle(id, ad, tc, tel)
            return True, "Çiftçi kaydı başarıyla güncellendi."
        except Exception as e:
            return False, f"Veritabanı Hatası: {str(e)}"
        

    def urunleri_listele(self):
        return self.dal.urunleri_getir()

    def sepeti_getir(self, musteri_id):
        return self.dal.sepeti_getir(musteri_id)

    def sepete_ekle(self, musteri_id, urun_id, miktar):
        try:
            miktar = int(miktar)
            if miktar <= 0:
                return False, "HATA: Miktar 0'dan büyük olmalıdır!"
                
            # İşte senin istediğin Stok Kontrolü:
            mevcut_stok = self.dal.stok_getir(urun_id)
            if miktar > mevcut_stok:
                return False, f"STOK UYARISI: Depoda yeterli ürün yok! (Kalan Stok: {mevcut_stok} adet)"
                
            self.dal.sepete_ekle(musteri_id, urun_id, miktar)
            return True, "Ürün çiftçinin sepetine başarıyla eklendi."
        except Exception as e:
            return False, f"Hata: {str(e)}"

    def sepetten_sil(self, sepet_id):
        try:
            self.dal.sepetten_sil(sepet_id)
            return True, "Ürün iptal edildi, stok depoya geri eklendi."
        except Exception as e:
            return False, f"Hata: {str(e)}"