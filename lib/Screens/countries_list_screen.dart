import 'package:covid_tracker/APIModel/covid_status_report.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import 'country_individual_screen.dart';

class CountriesListScreen extends StatefulWidget {
  const CountriesListScreen({Key? key}) : super(key: key);

  @override
  _CountriesListScreenState createState() => _CountriesListScreenState();
}

class _CountriesListScreenState extends State<CountriesListScreen> {
  TextEditingController searchController = TextEditingController();
  CovidReport covidRecords = CovidReport();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: RefreshIndicator(
        color:Colors.blue,
        backgroundColor: Colors.white,
        onRefresh: () {
          return Future.delayed(Duration(seconds: 1), () {
            final snackBar = SnackBar(
              content: Text('Screen Refreshed',
                  style: TextStyle(color: Colors.black)),
              elevation: 4,
              backgroundColor: Colors.blueGrey.shade50,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            setState(() {});
          });
        },
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    hintText: 'Search with country name',
                    suffixIcon: searchController.text.isEmpty
                        ? const Icon(Icons.search)
                        : GestureDetector(
                            onTap: () {
                              searchController.text = "";
                              setState(() {});
                            },
                            child: const Icon(Icons.clear)),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Expanded(
                child: FutureBuilder(
                    future: covidRecords.countriesListApi(),
                    builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                      if (!snapshot.hasData) {
                        return ListView.builder(
                          itemCount: 9,
                          itemBuilder: (context, index) {
                            return Shimmer(
                              duration: const Duration(seconds: 3),
                              interval: const Duration(seconds: 5),
                              color: Colors.grey,
                              colorOpacity: 0.5,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Container(
                                      height: 50,
                                      width: 50,
                                      color: Colors.white,
                                    ),
                                    title: Container(
                                      width: double.infinity,
                                      height: 8.0,
                                      color: Colors.white,
                                    ),
                                    subtitle: Container(
                                      width: double.infinity,
                                      height: 8.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              String name = snapshot.data![index]['country'];
                              if (searchController.text.isEmpty) {
                                return countryEffect(snapshot, index);
                              } else if (name.toLowerCase().contains(
                                  searchController.text.toLowerCase()) && snapshot.hasData) {
                                return countryEffect(snapshot, index);
                              } else {
                                return Container();
                              }
                            });
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget countryEffect(AsyncSnapshot<List<dynamic>> snapshot, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => country_individual_screen(
                      image: snapshot.data![index]['countryInfo']['flag'],
                      name: snapshot.data![index]['country'],
                      totalCases: snapshot.data![index]['cases'],
                      totalRecovered: snapshot.data![index]['recovered'],
                      totalDeaths: snapshot.data![index]['deaths'],
                      active: snapshot.data![index]['active'],
                      test: snapshot.data![index]['tests'],
                      todayRecovered: snapshot.data![index]['todayRecovered'],
                      critical: snapshot.data![index]['critical'],
                    )));
      },
      child: ListTile(
        leading: SizedBox(
            height: 40,
            width: 50,
            child: Image.network(
              snapshot.data![index]['countryInfo']['flag'],
              fit: BoxFit.contain,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress != null) {
                  return Center(
                      child: CircularProgressIndicator(color: Colors.white));
                } else {
                  return child;
                }
              },
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stacktrace) {
                return Center(
                    child: CircularProgressIndicator(color: Colors.white));
              },
            )),
        title: Text(snapshot.data![index]['country']),
        subtitle:
            Text("Effected: " + snapshot.data![index]['cases'].toString()),
      ),
    );
  }
}
