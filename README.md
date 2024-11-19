# :earth_asia: :shopping_cart: Proyek-Tengah-Semester-A08

# :boom: Nama Anggota Kelompok A08 :boom:
1. Ananda Dwi Hanifa (2306165572)
2. Erland Hafizh Aristovi (2306165686) 
3. Raysha Reifika Ryzki (2306208426)
4. Ridya Azizah Khayyira Mumtaz (2306245895)
5. Talitha Zenda Shakira (2306245554)

# Deskripsi Aplikasi
ManganJogja hadir untuk membantu penduduk lokal dan wisatawan dalam menemukan makanan atau minuman di kota ini dengan lebih mudah. Jogja terkenal sebagai kota wisata yang memiliki banyak pilihan kuliner. Namun, tidak semua orang familiar dengan lokasi tempat makanan atau minuman tertentu dijual.

Dengan ManganJogja, pengguna dapat dengan cepat mencari menu makanan atau minuman yang ada di Kota Jogja beserta rekomendasi restoran yang menyajikan menu tersebut. ManganJogja menampilkan beberapa fitur utama yang akan dikembangkan oleh tim, termasuk fitur pencarian, pemesanan tempat, dan ulasan pengguna. Selain itu, admin dapat menambahkan menu makanan atau minuman, serta rekomendasi restoran untuk setiap menu.

# :arrow_forward: Daftar Modul yang Akan Diimplementasikan :arrow_backward:
## **Main Page - Ridya** :computer:
Page ini merupakan penghubung antara fitur-fitur pada aplikasi ManganJogja. Main page akan menampilkan daftar menu dan rekomendasi restoran di dalamnya, dilengkapi dengan search bar dan filter untuk membantu pencarian menu atau restoran yang sesuai dengan keinginan user

## **Reserve - Raysha** :book:
Fitur reserve pada aplikasi Mangan Jogja hanya dapat digunakan oleh pengguna yang telah login (user). Pengguna dapat memesan tempat di restoran pilihan mereka dengan mengisi formulir yang mencakup nama, waktu kedatangan, jumlah tamu, dan detail lainnya. Setelah formulir diisi dan dikirimkan, pengguna akan diarahkan ke halaman terms and conditions yang memiliki tombol reserve. Setelah menyelesaikan proses ini, reservasi restoran berhasil dilakukan. Namun, pengguna tetap memiliki opsi untuk membatalkan pemesanan melalui halaman reserve.

## **Pemesanan takeaway - Erland** :label:
Fitur pemesanan takeaway merupakan fitur yang memungkinkan user untuk memesan makanan atau minuman untuk diambil secara takeaway. Fitur ini juga memungkinkan untuk memesan lebih dari 1 makanan/minuman pada restoran yang berbeda, disertakan dengan estimasi waktu dibuatnya makanan/minuman tersebut. Fitur ini mengasumsikan pengguna untuk melakukan pembayaran di tempat, sehingga tidak menyediakan online integrated payment.

## **Review - Talitha** :star:
Fitur review dalam aplikasi Mangan Jogja membantu pengguna yang telah membuat akun dan login untuk memberikan ulasan dan rating terhadap restoran atau kafe yang telah mereka kunjungi. Setiap pengguna dapat menulis ulasan berupa teks, memberikan rating dalam bentuk bintang (misalnya 1-5), dan menambahkan foto terkait pengalaman mereka. Ulasan ini akan ditampilkan pada halaman restoran, sehingga pengguna lain dapat melihat dan mempertimbangkan pilihan tempat makan berdasarkan ulasan tersebut. Selain itu, pemilik restoran dapat membalas ulasan untuk meningkatkan interaksi dengan pelanggan. Fitur ini bertujuan untuk memudahkan pengguna lain dalam menemukan tempat makan berdasarkan pengalaman nyata dari orang lain di aplikasi Mangan Jogja.

## **Wish list - Hanifa** :bookmark_tabs:
Fitur wish list memungkinkan pengguna untuk mengelola daftar produk (restoran) yang ingin mereka simpan atau pantau. Pengguna dapat menambahkan restoran yang ingin dikunjungi dan juga dapat menghapus restoran dari daftar list. Selain itu pengguna dapat menambahkan notes dari setiap wish list agar dapat mencatat informasi tambahan.

# :technologist: Role atau Peran Pengguna :ok_man:
1. Guest: User yang tidak melakukan login atau tidak memiliki akun. Oleh karena itu, guest hanya bisa melihat homepage tanpa melihat lebih dalam.
2. User: Pengguna yang telah membuat akun dan login ke dalam aplikasi. User memiliki akses lebih luas dibandingkan guest, seperti memberikan ulasan atau rating terhadap produk makanan dan minuman. User juga dapat berinteraksi dengan modul-modul lain, seperti memanfaatkan fitur pencarian produk dan melihat kategori makanan.

# :link: Tautan Deployment :link:
Link deployment: http://raysha-reifika-manganjogja.pbp.cs.ui.ac.id

# ⏫ **Alur Pengintegrasian** ⏫

Membuat fungsi baru untuk menerima request dari aplikasi mobile menggunakan metode GET dan POST. Pada aplikasi mobile berbasis Flutter, menambahkan request ke URL fungsi tersebut serta memproses data yang diterima dari hasil request. Web service Django akan memberikan respon dalam format JSON. Melakukan debugging dan memperbaiki kesalahan atau masalah yang ditemukan hingga aplikasi berfungsi dengan baik sesuai dengan persyaratan yang diharapkan.

