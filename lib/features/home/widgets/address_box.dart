import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressBox extends StatelessWidget {
  const AddressBox({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().user;

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          stops: [0.5, 1.0],
          colors: [
            Color.fromARGB(255, 114, 226, 221),
            Color.fromARGB(255, 163, 236, 233),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          height: 40,
          width: MediaQuery.sizeOf(context).width,
          child: Row(
            children: [
              /// #location icon
              const Icon(Icons.location_on_outlined, size: 20),
              const SizedBox(width: 10),

              /// #delivery to name - address text
              Expanded(
                child: Text(
                  'Delivery to ${user.name} - ${user.address.isNotEmpty ? 'Write your address' : user.address}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),

              /// #drop down icon
              IconButton(
                onPressed: () {},
                iconSize: 20,
                icon: const Icon(Icons.arrow_drop_down_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
