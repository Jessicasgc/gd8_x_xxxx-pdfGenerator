import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gd8_library_xxxx/get_total_invoice.dart';
import 'package:gd8_library_xxxx/model/product.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:io' show Platform;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uuid/uuid.dart';
import 'package:gd8_library_xxxx/preview_screen.dart';
import 'package:gd8_library_xxxx/custom_row_invoice.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final nameController = TextEditingController();
  final birthdayController = TextEditingController();
  final ageController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final majorController = TextEditingController();
  final facultyController = TextEditingController();
  final universityController = TextEditingController();
  String id = const Uuid().v1(); // untuk membuat kode unik berdasarkan waktu
  File? image;
  List<Product> soldProducts = [];
  // untuk input pemilihan gambar dari galeri
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      debugPrint(
          'Failed to pick image: $e'); //untuk cek saat di log dan sebaiknya dihapus ketika deploy app, namun dapat ditambah dengan toast
    }
  }

  //untuk input pemilihan gambar dari kamera
  Future pickImageC() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      debugPrint(
          'Failed to pick image: $e'); //untuk cek saat di log dan sebaiknya dihapus ketika deploy app, namun dapat ditambah dengan toast
    }
  }

  List<Product> products = [
    Product("Membership", 9.99, 19),
    Product("Nails", 0.30, 19),
    Product("Hammer", 26.43, 19),
    Product("Hamburger", 5.99, 7),
  ];
  int number = 0;
  getTotal() => products
      .fold(0.0,
          (double prev, element) => prev + (element.price * element.amount))
      .toStringAsFixed(2);

  getVat() => products
      .fold(
          0.0,
          (double prev, element) =>
              prev +
              (element.price / 100 * element.vatInPercent * element.amount))
      .toStringAsFixed(2);
  //tampilan input berbentuk form yang terdiri dari:
  // -button,
  // -preview gambar yang dipilih,
  // -textformfield
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'Modul 8 Library',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15.sp,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 180,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final currentProduct = products[index];
                        return Row(
                          children: [
                            Expanded(child: Text(currentProduct.name)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      "Price: ${currentProduct.price.toStringAsFixed(2)} €"),
                                  Text(
                                      "VAT ${currentProduct.vatInPercent.toStringAsFixed(0)} %")
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() => currentProduct.amount++);
                                      },
                                      icon: const Icon(Icons.add),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      currentProduct.amount.toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() => currentProduct.amount--);
                                      },
                                      icon: const Icon(Icons.remove),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        );
                      },
                      itemCount: products.length,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [const Text("VAT"), Text("${getVat()} €")],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [const Text("Total"), Text("${getTotal()} €")],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(3.h),
              child: Column(children: [
                Center(
                  child: Text(
                    'Fill This Form',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Center the buttons horizontally
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 8.sp,
                          ),
                        ),
                        onPressed: () {
                          pickImageC();
                        },
                        child: const Text("Pick Image from Camera"),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 2.h),
                          backgroundColor: Colors.amber,
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 8.sp,
                          ),
                        ),
                        onPressed: () {
                          pickImage();
                        },
                        child: const Text("Pick Image from Gallery"),
                      ),
                    ),
                    SizedBox(
                        width: 10.w), // Add some spacing between the buttons
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                if (image != null)
                  Column(
                    children: [
                      //jika pada web menggunakan Image.network, jika selain web menggunakan Image.file
                      kIsWeb ? Image.network(image!.path) : Image.file(image!),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.h),
                        child: IconButton(
                          color: Colors.red,
                          iconSize: 5.h,
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              image = null;
                            });
                          },
                        ),
                      )
                    ],
                  )
                else
                  const Text("No image selected"),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      hintText: 'Enter Your Name', labelText: 'Name'),
                ),
                TextFormField(
                  controller: birthdayController,
                  decoration: const InputDecoration(
                      hintText: 'Enter Your Birthday', labelText: 'Birthday'),
                  keyboardType: TextInputType.datetime,
                ),
                TextFormField(
                  controller: ageController,
                  decoration: const InputDecoration(
                      hintText: 'Enter Your Age', labelText: 'Age'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                      hintText: 'Enter Your Phone Number',
                      labelText: 'Phone Number'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                      hintText: 'Enter Your Address', labelText: 'Address'),
                ),
                TextFormField(
                  controller: majorController,
                  decoration: const InputDecoration(
                      hintText: 'Enter Your Major', labelText: 'Major'),
                ),
                TextFormField(
                  controller: facultyController,
                  decoration: const InputDecoration(
                      hintText: 'Enter Your Faculty', labelText: 'Faculty'),
                ),
                TextFormField(
                  controller: universityController,
                  decoration: const InputDecoration(
                      hintText: 'Enter Your University',
                      labelText: 'University'),
                ),
              ]),
            ),
            //Input Product

            Container(
              margin: EdgeInsets.symmetric(vertical: 2.h),
              child: ElevatedButton(
                onPressed: () {
                  if (image == null ||
                      nameController.text.isEmpty ||
                      birthdayController.text.isEmpty ||
                      ageController.text.isEmpty ||
                      phoneController.text.isEmpty ||
                      addressController.text.isEmpty ||
                      majorController.text.isEmpty ||
                      facultyController.text.isEmpty ||
                      universityController.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Warning'),
                        content: const Text(
                            'Please fill in all the required fields.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                    return; // Stop PDF creation if fields are empty
                  } else {
                    createPdf();
                    setState(() {
                      const uuid = Uuid();
                      id = uuid.v1();
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                  ),
                ),
                child: const Text('create pdf'),
              ),
            )
          ],
        ),
      ),
    );
  }

  void createPdf() async {
    final doc = pw.Document();
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd\n  HH:mm:ss')
        .format(now); //menampilkan waktu terbuatnya dokumen PDF

    //mengambil gambar dari asset untuk ditampilkan pada dokumen PDF
    final imageBytesHeader =
        (await rootBundle.load("assets/college.png")).buffer.asUint8List();
    final imageHeader = pw.MemoryImage(imageBytesHeader);

    //mengambil gambar dari input galeri atau kamera
    pw.ImageProvider pdfImageProvider(Uint8List imageBytes) {
      return pw.MemoryImage(imageBytes);
    }

    //Jika tidak input gambar maka tidak dapat create pdf karena kondisinya hanya dapat menampilkan dokumen pdf jika gambar tidak null
    if (image != null &&
        nameController.text.isNotEmpty &&
        ageController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        majorController.text.isNotEmpty &&
        facultyController.text.isNotEmpty &&
        universityController.text.isNotEmpty) {
      final imageBytes = image!.readAsBytesSync();

      //Memberi border pada dokumen pdf
      final pdfTheme = pw.PageTheme(
        pageFormat: PdfPageFormat.a4,
        buildBackground: (pw.Context context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                color: PdfColor.fromHex('#FFBD59'),
                width: 1.w,
              ),
            ),
          );
        },
      );

// final List<CustomRow> elements = [
//       CustomRow("Item Name", "Item Price", "Amount", "Total", "Vat"),
//       for (var product in soldProducts)
//         CustomRow(
//           product.name,
//           product.price.toStringAsFixed(2),
//           product.amount.toStringAsFixed(2),
//           (product.price * product.amount).toStringAsFixed(2),
//           (product.vatInPercent * product.price).toStringAsFixed(2),
//         ),
//       CustomRow(
//         "Sub Total",
//         "",
//         "",
//         "",
//         "${getSubTotal(soldProducts)} EUR",
//       ),
//       CustomRow(
//         "Vat Total",
//         "",
//         "",
//         "",
//         "${getVatTotal(soldProducts)} EUR",
//       ),
//       CustomRow(
//         "Vat Total",
//         "",
//         "",
//         "",
//         "${(double.parse(getSubTotal(soldProducts)) + double.parse(getVatTotal(soldProducts))).toStringAsFixed(2)} EUR",
//       )
//     ];

      // final imageLogo = (await rootBundle.load("assets/flutter_explained_logo.jpg"))
      //     .buffer
      //     .asUint8List();
      //Pengaturan tampilan dokumen PDFnya
      // Di sini menggunakan Multi Page agar dapat menampilkan lebih dari 1 halaman.
      //kemudian menggunakan header untuk header dokumen PDF, build untuk isi dokumen PDFnya, dan footer untuk footer dokumen PDF
      doc.addPage(
        pw.MultiPage(
          pageTheme: pdfTheme,
          header: (pw.Context context) {
            return pw.Header(
                margin: pw.EdgeInsets.zero,
                outlineColor: PdfColors.amber50,
                outlineStyle: PdfOutlineStyle.normal,
                level: 5,
                decoration: pw.BoxDecoration(
                  shape: pw.BoxShape.rectangle,
                  gradient: pw.LinearGradient(
                    colors: [
                      PdfColor.fromHex('#FCDF8A'),
                      PdfColor.fromHex('#F38381')
                    ],
                    begin: pw.Alignment.topLeft,
                    end: pw.Alignment.bottomRight,
                  ),
                ),
                child: pw.Container(
                  child: pw.Center(
                      child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Center(
                        child: pw.Text(
                          'Identity Documentation',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 8.sp,
                          ),
                        ),
                      ),
                      pw.Image(imageHeader,
                          height: 5.h,
                          width: 5.w,
                          alignment: pw.Alignment.topLeft)
                    ],
                  ) //pw.Image(Image.asset('college.png') as pw.ImageProvider),
                      ),
                ));
          },
          build: (pw.Context context) {
            return [
              pw.Center(
                  child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                    pw.Container(
                        margin: pw.EdgeInsets.symmetric(
                            horizontal: 2.h, vertical: 2.h)),
                    pw.Padding(
                      padding: pw.EdgeInsets.symmetric(
                          horizontal: 2.h, vertical: 1.h),
                      child: pw.FittedBox(
                        child:
                            pw.Image(pdfImageProvider(imageBytes), width: 33.h),
                        fit: pw.BoxFit.fitHeight,
                        alignment: pw.Alignment.center,
                      ),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.symmetric(
                          horizontal: 2.h, vertical: 1.h),
                      child: pw.Text('Created at',
                          style: pw.TextStyle(
                              fontSize: 5.sp, color: PdfColors.blue)),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.symmetric(horizontal: 2.h),
                      child: pw.Text(formattedDate,
                          style: pw.TextStyle(
                              fontSize: 5.sp, color: PdfColors.blue)),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.symmetric(
                          horizontal: 5.h, vertical: 1.h),
                      child: pw.Table(
                        border: pw.TableBorder.all(),
                        children: [
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.symmetric(
                                    horizontal: 1.h, vertical: 1.h),
                                child: pw.Text(
                                  'Name',
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 3.sp,
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.symmetric(
                                    horizontal: 1.h, vertical: 1.h),
                                child: pw.Text(
                                  nameController.text,
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 3.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.symmetric(
                                    horizontal: 1.h, vertical: 1.h),
                                child: pw.Text(
                                  'Birthday',
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 3.sp,
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.symmetric(
                                    horizontal: 1.h, vertical: 1.h),
                                child: pw.Text(
                                  birthdayController.text,
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 3.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.symmetric(
                                    horizontal: 1.h, vertical: 1.h),
                                child: pw.Text(
                                  'Age',
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 3.sp,
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.symmetric(
                                    horizontal: 1.h, vertical: 1.h),
                                child: pw.Text(
                                  ageController.text,
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 3.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.symmetric(
                                    horizontal: 1.h, vertical: 1.h),
                                child: pw.Text(
                                  'Phone Number',
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 3.sp,
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.symmetric(
                                    horizontal: 1.h, vertical: 1.h),
                                child: pw.Text(
                                  phoneController.text,
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 3.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.symmetric(
                                    horizontal: 1.h, vertical: 1.h),
                                child: pw.Text(
                                  'Address',
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 3.sp,
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.symmetric(
                                    horizontal: 1.h, vertical: 1.h),
                                child: pw.Text(
                                  addressController.text,
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 3.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.symmetric(
                                    horizontal: 1.h, vertical: 1.h),
                                child: pw.Text(
                                  'Major',
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 3.sp,
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.symmetric(
                                    horizontal: 1.h, vertical: 1.h),
                                child: pw.Text(
                                  majorController.text,
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 3.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.symmetric(
                                    horizontal: 1.h, vertical: 1.h),
                                child: pw.Text(
                                  'Faculty',
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 3.sp,
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.symmetric(
                                    horizontal: 1.h, vertical: 1.h),
                                child: pw.Text(
                                  facultyController.text,
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 3.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.symmetric(
                                    horizontal: 1.h, vertical: 1.h),
                                child: pw.Text(
                                  'University',
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 3.sp,
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.symmetric(
                                    horizontal: 1.h, vertical: 1.h),
                                child: pw.Text(
                                  universityController.text,
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 3.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                          children: [
                            pw.Text("Customer Name"),
                            pw.Text("Customer Address"),
                            pw.Text("Customer City"),
                          ],
                        ),
                        pw.Column(
                          children: [
                            pw.Text("Max Weber"),
                            pw.Text("Weird Street Name 1"),
                            pw.Text("77662 Not my City"),
                            pw.Text("Vat-id: 123456"),
                            pw.Text("Invoice-Nr: 00001")
                          ],
                        )
                      ],
                    ),
                    pw.SizedBox(height: 50),
                    pw.Text(
                        "Dear Customer, thanks for buying at Flutter Explained, feel free to see the list of items below."),
                    pw.SizedBox(height: 25),
                    //itemColumn(elements),
                    pw.SizedBox(height: 25),
                    pw.Text("Thanks for your trust, and till the next time."),
                    pw.SizedBox(height: 25),
                    pw.Text("Kind regards,"),
                    pw.SizedBox(height: 25),
                    pw.Text("Max Weber"),
                    pw.Padding(
                      padding: pw.EdgeInsets.symmetric(
                          horizontal: 1.h, vertical: 1.h),
                      child: pw.Stack(
                        alignment: pw.Alignment.center,
                        children: [
                          pw.BarcodeWidget(
                            barcode: pw.Barcode.qrCode(
                              errorCorrectLevel: BarcodeQRCorrectionLevel.high,
                            ),
                            data: id,
                            width: 15.w,
                            height: 15.h,
                          ),
                        ],
                      ),
                    ),
                  ])), //
            ];
          },
          footer: (pw.Context context) {
            return pw.Container(
                color: PdfColor.fromHex('#FFBD59'),
                child: pw.Center(child: pw.Text('-Modul 8 Library-')));
          },
        ),
      ); // Page
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PreviewScreen(doc: doc),
          ));
    }
  }
}

pw.Expanded itemColumn(List<CustomRow> elements) {
  return pw.Expanded(
    child: pw.Column(
      children: [
        for (var element in elements)
          pw.Row(
            children: [
              pw.Expanded(
                  child:
                      pw.Text(element.itemName, textAlign: pw.TextAlign.left)),
              pw.Expanded(
                  child: pw.Text(element.itemPrice,
                      textAlign: pw.TextAlign.right)),
              pw.Expanded(
                  child:
                      pw.Text(element.amount, textAlign: pw.TextAlign.right)),
              pw.Expanded(
                  child: pw.Text(element.total, textAlign: pw.TextAlign.right)),
              pw.Expanded(
                  child: pw.Text(element.vat, textAlign: pw.TextAlign.right)),
            ],
          )
      ],
    ),
  );
}
