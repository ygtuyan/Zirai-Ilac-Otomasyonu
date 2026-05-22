from flask import Flask, render_template, request, redirect, url_for, flash
from business import BusinessLayer

app = Flask(__name__)
app.secret_key = "zirai_proje_gizli_anahtari"

bl = BusinessLayer()

@app.route('/')
def index():
    ciftciler = bl.musteri_listele()
    return render_template('musteriler.html', musteriler=ciftciler)

@app.route('/musteri-ekle', methods=['POST'])
def musteri_ekle():
    if request.method == 'POST':
        ad = request.form.get('ad_soyad')
        tc = request.form.get('tc_no')
        tel = request.form.get('telefon')
        
        basarili_mi, mesaj = bl.musteri_kaydet(ad, tc, tel)
        
        flash(mesaj)
        return redirect(url_for('index'))
    


@app.route('/musteri-guncelle/<int:id>', methods=['GET', 'POST'])
def musteri_guncelle(id):
    if request.method == 'POST':
        # Formdan gelen yeni bilgileri al ve iş katmanına yolla
        ad = request.form.get('ad_soyad')
        tc = request.form.get('tc_no')
        tel = request.form.get('telefon')
        
        basarili_mi, mesaj = bl.musteri_guncelle(id, ad, tc, tel)
        flash(mesaj)
        return redirect(url_for('index'))
    
    # Eğer GET isteği ise (Yani butona yeni tıklandıysa, sayfa açılıyorsa)
    # Mevcut müşteriyi listeden bulup forma göndermeliyiz
    ciftciler = bl.musteri_listele()
    secili_kisi = None
    for c in ciftciler:
        if c['ID'] == id:
            secili_kisi = c
            break
            
    return render_template('guncelle.html', kisi=secili_kisi)
    
@app.route('/musteri-sil/<int:id>')
def musteri_sil(id):
    basarili_mi, mesaj = bl.musteri_sil(id)
    flash(mesaj)
    return redirect(url_for('index'))

@app.route('/sepet/<int:id>', methods=['GET', 'POST'])
def musteri_sepeti(id):
    # Müşteri bilgilerini bulalım (Başlıkta göstermek için)
    ciftciler = bl.musteri_listele()
    secili_kisi = next((c for c in ciftciler if c['ID'] == id), None)
    
    if request.method == 'POST':
        urun_id = request.form.get('urun_id')
        miktar = request.form.get('miktar')
        
        basarili_mi, mesaj = bl.sepete_ekle(id, urun_id, miktar)
        flash(mesaj)
        return redirect(url_for('musteri_sepeti', id=id))
        
    sepet_icerigi = bl.sepeti_getir(id)
    urunler = bl.urunleri_listele()
    
    return render_template('sepet.html', kisi=secili_kisi, sepet=sepet_icerigi, urunler=urunler)

@app.route('/sepetten-sil/<int:musteri_id>/<int:sepet_id>')
def sepetten_sil(musteri_id, sepet_id):
    basarili_mi, mesaj = bl.sepetten_sil(sepet_id)
    flash(mesaj)
    return redirect(url_for('musteri_sepeti', id=musteri_id))

if __name__ == '__main__':
    app.run(debug=True)







