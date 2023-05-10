import "package:cart/cart_model.dart";
import "package:cart/cart_provider.dart";
import "package:cart/db_helper.dart";
import "package:flutter/material.dart";
import "package:badges/badges.dart"as badges;
import "package:flutter/services.dart";
import "package:provider/provider.dart";

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  DBHelper? dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text('My Products', style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold),),
          centerTitle: true, backgroundColor: Colors.blue,
          actions:   [
            Center(
              child: badges.Badge(
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value, child){
                    return Text(value.getCounter().toString(), style: const TextStyle(color: Colors.white));
                  },
                ),
                //animationDuration: Duration(milliseconds: 300),
                child: const Icon(Icons.shopping_cart_sharp,size: 30,),
              ),
            ),
            const SizedBox(width: 20,),
          ]
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            FutureBuilder(
                future: cart.getData(),
                builder: (context, AsyncSnapshot<List<Cart>> snapshot){
              if(snapshot.hasData){
                if(snapshot.data!.isEmpty){
                  return  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Center(
                        child: Image(
                            height: 800, width: 800,
                            fit: BoxFit.fitWidth,
                            filterQuality: FilterQuality.high,
                            image: AssetImage('images/empty_cart.jpg')),
                      ),
                    ],
                  );
                }else{
                  return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context,index){
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Image(
                                            height:200 , width: 200,
                                            image:
                                            NetworkImage(snapshot.data![index].image.toString())),
                                        const SizedBox(width: 20,),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(snapshot.data![index].productName.toString(),style: const TextStyle(fontSize: 45,fontWeight: FontWeight.w400),),
                                                InkWell(
                                                    onTap: (){
                                                      dbHelper!.delete(snapshot.data![index].id!);
                                                      cart.removeCounter();
                                                      cart.removeTotalPrice(double.parse(snapshot.data![index].productPrice.toString()));
                                                    },
                                                    child: const Icon(Icons.delete_outline,color: Colors.red,size: 40,))
                                              ],
                                            ),
                                            const SizedBox(height: 10,),
                                            Text(snapshot.data![index].unitTag!.toString()+' '+'Rs: '+snapshot.data![index].productPrice.toString(),style: const TextStyle(fontSize: 32,fontWeight: FontWeight.w300),),
                                          ],
                                        ),
                                        const Spacer(),
                                        InkWell(
                                          onTap: (){

                                          },
                                          child: Container(
                                            height: 60, width: 160,
                                            decoration: BoxDecoration(
                                                color: Colors.blue, borderRadius: BorderRadius.circular(10)
                                            ),
                                            child:  Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                children:  [
                                                  InkWell(
                                                      onTap: (){
                                                        int quantity = snapshot.data![index].quantity!;
                                                        int price = snapshot.data![index].initialPrice!;
                                                        quantity--;
                                                        int? newPrice = price * quantity;
                                                        if(quantity > 0){
                                                          dbHelper!.updateQuantity(
                                                              Cart(
                                                                  id: snapshot.data![index].id!,
                                                                  productID: snapshot.data![index].productID!.toString(),
                                                                  productName: snapshot.data![index].productName!.toString(),
                                                                  initialPrice: snapshot.data![index].initialPrice!,
                                                                  quantity: quantity,
                                                                  productPrice: newPrice,
                                                                  unitTag: snapshot.data![index].unitTag!.toString(),
                                                                  image: snapshot.data![index].image!.toString())
                                                          ).then((value){
                                                            newPrice = 0;
                                                            quantity = 0;
                                                            cart.removeTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                          }).onError((error, stackTrace){
                                                            print(error.toString());
                                                          });
                                                        }
                                                      },
                                                      child: const Icon(Icons.remove,size: 31,color: Colors.white,)),
                                                  const Spacer(),
                                                  Text(snapshot.data![index].quantity!.toString(),style:
                                                  const TextStyle(color: Colors.white,fontSize: 26),),
                                                  const Spacer(),
                                                  InkWell(
                                                      onTap: (){
                                                        int quantity = snapshot.data![index].quantity!;
                                                        int price = snapshot.data![index].initialPrice!;
                                                        quantity++;
                                                        int? newPrice = price * quantity;
                                                        dbHelper!.updateQuantity(
                                                            Cart(
                                                                id: snapshot.data![index].id!,
                                                                productID: snapshot.data![index].productID!.toString(),
                                                                productName: snapshot.data![index].productName!.toString(),
                                                                initialPrice: snapshot.data![index].initialPrice!,
                                                                quantity: quantity,
                                                                productPrice: newPrice,
                                                                unitTag: snapshot.data![index].unitTag!.toString(),
                                                                image: snapshot.data![index].image!.toString())
                                                        ).then((value){
                                                          newPrice = 0;
                                                          quantity = 0;
                                                          cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                        }).onError((error, stackTrace){
                                                          print(error.toString());
                                                        });
                                                      },
                                                      child: const Icon(Icons.add,size: 31,color: Colors.white,)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          })
                  );
                }
              }else{
                return const Text('NOT DATA');
              }
            }),
            Consumer<CartProvider>(
                builder: (context, value, child){
              return Visibility(
                visible: value.getTotalPrice().toStringAsFixed(2) == "0.00" ? false : true,
                child: Column(
                  children:  [
                    ReusableWidget(title: 'Sub Total:', value: r'Rs '+value.getTotalPrice().toStringAsFixed(2)),
                    ReusableWidget(title: 'Discount 5%:', value: r'Rs '+'20'),
                    ReusableWidget(title: 'Total:', value: r'Rs '+value.getTotalPrice().toStringAsFixed(2))

                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium,),
          Text(value.toString(), style: Theme.of(context).textTheme.headlineMedium,)
        ],
      ),
    );
  }
}