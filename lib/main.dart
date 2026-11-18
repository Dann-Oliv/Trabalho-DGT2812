import 'package:flutter/material.dart';

void main() {
  runApp(const ExploreMundoApp());
}

class ExploreMundoApp extends StatelessWidget {
  const ExploreMundoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Explore Mundo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff1769aa)),
        useMaterial3: true,
      ),
      home: const ExploreHomePage(),
    );
  }
}

class ExploreHomePage extends StatefulWidget {
  const ExploreHomePage({super.key});

  @override
  State<ExploreHomePage> createState() => _ExploreHomePageState();
}

class _ExploreHomePageState extends State<ExploreHomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  final List<Destination> _destinations = const [
    Destination(
      name: 'Oeschinen Lake',
      location: 'Kandersteg, Suíça',
      description: 'Paisagens alpinas, trilhas e um lago perfeito para dias de descanso.',
      rating: 41,
      icon: Icons.landscape,
    ),
    Destination(
      name: 'Fernando de Noronha',
      location: 'Pernambuco, Brasil',
      description:
          'Praias preservadas, águas cristalinas e experiências inesquecíveis.',
      rating: 38,
      icon: Icons.waves,
    ),
    Destination(
      name: 'Santorini',
      location: 'Cíclades, Grécia',
      description:
          'Arquitetura, pôr do sol e cultura mediterrânea em um único destino.',
      rating: 35,
      icon: Icons.wb_sunny,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Destination> get _filteredDestinations {
    final query = _searchTerm.trim().toLowerCase();
    if (query.isEmpty) {
      return _destinations;
    }
    return _destinations
        .where(
          (destination) =>
              destination.name.toLowerCase().contains(query) ||
              destination.location.toLowerCase().contains(query),
        )
        .toList();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Mundo'),
        actions: [
          TextButton(
            onPressed: () => _showMessage('Confira nossos destinos.'),
            child: const Text('Destinos'),
          ),
          TextButton(
            onPressed: () => _showMessage('Pacotes em breve.'),
            child: const Text('Pacotes'),
          ),
          IconButton(
            tooltip: 'Contato',
            onPressed: () => _showMessage('Fale com nossa equipe.'),
            icon: const Icon(Icons.contact_phone),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          _buildBanner(),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
            child: Text(
              'Encontre sua próxima viagem',
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchTerm = value),
              decoration: InputDecoration(
                hintText: 'Pesquisar destinos',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchTerm.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Limpar pesquisa',
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchTerm = '');
                        },
                        icon: const Icon(Icons.clear),
                      ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          ..._filteredDestinations.map(
            (destination) => _buildDestinationCard(destination, color),
          ),
          if (_filteredDestinations.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: Text('Nenhum destino encontrado.')),
            ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Container(
          width: double.infinity,
          height: 220,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff83c9ed), Color(0xff173f68)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: const Icon(Icons.landscape, color: Colors.white70, size: 120),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          color: Colors.black54,
          child: const Text(
            'Descubra lugares que ficam para sempre na memória.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDestinationCard(Destination destination, Color color) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        destination.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        destination.location,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.star, color: Colors.amber[700]),
                Text('${destination.rating}'),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(destination.description),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButtonColumn(
                  color,
                  destination.icon,
                  'DETALHES',
                  () => _showMessage('Detalhes de ${destination.name}.'),
                ),
                _buildButtonColumn(
                  color,
                  Icons.calendar_month,
                  'RESERVAR',
                  () => _showMessage('Reserva iniciada.'),
                ),
                _buildButtonColumn(
                  color,
                  Icons.share,
                  'COMPARTILHAR',
                  () => _showMessage('Destino pronto para compartilhar.'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonColumn(
    Color color,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Destination {
  const Destination({
    required this.name,
    required this.location,
    required this.description,
    required this.rating,
    required this.icon,
  });

  final String name;
  final String location;
  final String description;
  final int rating;
  final IconData icon;
}
