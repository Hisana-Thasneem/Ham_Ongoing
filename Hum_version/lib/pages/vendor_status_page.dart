import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../helpers/reusables_helper.dart';
import '../helpers/enum_helper.dart';
import '../providers/vendor_provider.dart';
import '../providers/app_user_provider.dart';

class VendorStatusPage extends StatefulWidget {
  static const routeName = '/vendorstatuspage';

  const VendorStatusPage({Key? key}) : super(key: key);

  @override
  _VendorStatusPageState createState() => _VendorStatusPageState();
}

class _VendorStatusPageState extends State<VendorStatusPage> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isInit = false;
        _isLoading = true;
      });
      Provider.of<VendorProvider>(context, listen: false)
          .getVendors(
              Provider.of<AppUserProvider>(context, listen: false).appUser!.id)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        if (value == ProviderResponse.error) {
          displaySnackBar(
            context: context,
            text:
                'An unexpected error had occured while adding fetching vendor details, please check your internet connection or try again.',
          );
        }
      });
    }
    super.didChangeDependencies();
  }

  Widget statusCard({required Vendor vendor, required Color timestampColor}) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vendor.shopName,
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                  ),
                ),
                Text(
                  "Owned by ${vendor.ownerName}",
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                  ),
                ),
                Text(
                  vendor.address,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.mail,
                      size: 16,
                    ),
                    Text(
                      vendor.email,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      size: 16,
                    ),
                    Text(
                      vendor.mobileNumber,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.watch_later_outlined,
                      size: 16,
                    ),
                    Text(
                      DateFormat.yMMMd()
                          .add_jms()
                          .format(DateTime.parse(vendor.addedDate!)),
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: timestampColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'VENDOR STATUS',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w500,
              fontSize: MediaQuery.of(context).size.width > 390 ? 20 : 16,
            ),
          ),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(FontAwesomeIcons.clipboard),
              ),
              Tab(
                icon: Icon(FontAwesomeIcons.checkCircle),
              ),
              Tab(
                icon: Icon(FontAwesomeIcons.timesCircle),
              ),
            ],
          ),
        ),
        body: _isLoading
            ? loader(context)
            : TabBarView(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: Consumer<VendorProvider>(
                      builder: (_, vendorprovider, __) => ListView.builder(
                        itemCount: vendorprovider.pendingVendors.length,
                        itemBuilder: (ctx, index) => statusCard(
                          vendor: vendorprovider.pendingVendors[index],
                          timestampColor: Colors.orange,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Consumer<VendorProvider>(
                      builder: (_, vendorprovider, __) => ListView.builder(
                        itemCount: vendorprovider.approvedVendors.length,
                        itemBuilder: (ctx, index) => statusCard(
                          vendor: vendorprovider.pendingVendors[index],
                          timestampColor: Colors.green,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Consumer<VendorProvider>(
                      builder: (_, vendorprovider, __) => ListView.builder(
                        itemCount: vendorprovider.rejectedVendors.length,
                        itemBuilder: (ctx, index) => statusCard(
                          vendor: vendorprovider.pendingVendors[index],
                          timestampColor: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
