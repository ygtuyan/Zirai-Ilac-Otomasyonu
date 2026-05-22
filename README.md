# 🌾 Zirai İlaç Satış ve Takip Otomasyonu

Bu proje, zirai ilaç bayileri için geliştirilmiş, çiftçi kayıtlarının tutulduğu, ürün stok takibinin yapıldığı ve kişiye özel sepet mantığıyla satış işlemlerinin gerçekleştirildiği web tabanlı bir otomasyon sistemidir. 

Proje, yazılım mühendisliği prensiplerine uygun olarak **N-Katmanlı Mimari (N-Tier Architecture)** kullanılarak geliştirilmiştir. Tüm veritabanı işlemleri güvenlik ve performans amacıyla **Stored Procedure (Saklı Yordamlar)** üzerinden yürütülmektedir.

## 🚀 Projenin Özellikleri

* **N-Katmanlı Mimari:** Veri Erişim (DAL), İş (Business) ve Sunum (UI) katmanları birbirinden tamamen izole edilmiştir.
* **Müşteri Yönetimi (CRUD):** Çiftçi kayıtları eklenebilir, silinebilir, güncellenebilir ve listelenebilir (TCKN doğrulama kuralları içerir).
* **Akıllı Sepet Sistemi:** Her çiftçiye özel sepet açılabilir. Sepete ürün eklendiğinde genel toplam otomatik hesaplanır.
* **Dinamik Stok Kontrolü:** Sepete ürün eklendiğinde depodaki stok anında düşer. Stok miktarından fazla ürün satışı yapılmaya çalışıldığında sistem hata fırlatır. Ürün sepetten çıkarıldığında stok depoya iade edilir.
* **Güvenli Veritabanı Mimarisi:** Python içerisine doğrudan SQL sorguları yazmak yerine, işlemler MySQL tarafında önceden derlenmiş prosedürlerle (Stored Procedure) sağlanır.

## 🛠️ Kullanılan Teknolojiler

* **Backend:** Python, Flask
* **Veritabanı:** MySQL, `mysql-connector-python`
* **Frontend:** HTML5, Bootstrap 5, Jinja2 Template Engine

## 📂 Proje Klasör Yapısı

```text
Zirai-Ilac-Otomasyonu/
│
├── dal.py                    # Veri Erişim Katmanı (Veritabanı bağlantıları)
├── business.py               # İş Katmanı (Kurallar, stok kontrolleri, validasyonlar)
├── app.py                    # Sunum Katmanı (Flask rotaları ve web sunucusu)
├── veritabani_kurulum.sql    # Veritabanı tabloları ve Stored Procedure kodları
│
└── templates/                # Kullanıcı Arayüzü (HTML)
    ├── musteriler.html       # Çiftçi listesi ve kayıt ekranı
    ├── guncelle.html         # Çiftçi bilgi güncelleme ekranı
    └── sepet.html            # Sepet, ürün ekleme ve stok tablosu
```

Kurulum ve Çalıştırma Yönergesi
Projeyi kendi bilgisayarınızda çalıştırmak için aşağıdaki adımları izleyebilirsiniz:

1. Veritabanını Hazırlayın:

MySQL Workbench (veya benzeri bir araç) açın.

Proje dizinindeki veritabani_kurulum.sql dosyasının içindeki tüm kodları kopyalayıp çalıştırın. Bu işlem ZiraiIlacSistem veritabanını, tabloları, örnek ürünleri ve gerekli tüm prosedürleri otomatik kuracaktır.

2. Bağlantı Ayarlarını Yapın:

Kodu editörünüzde açın ve dal.py dosyasına gidin.

self.config bloğu içerisindeki password kısmına kendi MySQL şifrenizi yazın.

3. Gerekli Kütüphaneleri Kurun:
Terminali (Command Prompt) açın ve Flask ile MySQL sürücüsünü yükleyin:

Bash
pip install Flask mysql-connector-python
4. Projeyi Başlatın:
Terminal üzerinden proje klasörüne gidin ve uygulamayı ayağa kaldırın:

Bash
python app.py
Tarayıcınızı açın ve http://127.0.0.1:5000 adresine giderek sistemi kullanmaya başlayın!
