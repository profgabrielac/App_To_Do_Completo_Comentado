// Material é a interface para o ANDROID
// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'models/item.dart';
// Cupertino é a interface para IOS
//import 'package:flutter/cupertino.dart';

// Alguns widgets são especificos ou para ANDROID ou para IOS porém na hora de renderizar o app em algum celular
// ele consegue já identificar e renderizar na forma do SO atual
// A gente sempre vai começar com MaterialApp

// Tudo que é desenhado ou seja tudo que faz parte da tela do flutter são chamados de WIDGETS
// Os WIDGETS são divididos em dois StatelessWidget e StatefulWidget

// StatelessWidget : não possui estado, é só um desenho na tela, um elemento somente visual, não tem interação então não necessita de um estado
// StatefulWidget : quando você necessita manter o estado que está na tela, você deve criar um StatefulWidget

// Ao criar um StatelessWidget você pode converte-lô para StatefulWidget atráves de um recuso do VISUAL STUDIO CODE, o contrário já não é possível

// Para criar um StatelessWidget basta digitar stl + tab que o VS code já traz a estrutura
// Para criar um StatefulWidget basta digitar stf + tab que o VS code já traz a estrutura

// Pensando que cada widget é um pedaço da tela, podemos sempre reutilizar os widgets quando necessário
// Uma boa prática é dividirmos os widgets em 2 partes, PAGINAS e COMPONENTES

void main() {
  //função main sempre vai chamar um widget que pode ser StatelessWidget ou StatefulWidget
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //Swatch é a paleta de cores
        primarySwatch: Colors.blueGrey,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  //Criação da nossa lista de itens inicialmente vazia
  List<Item> items = [];

  //Inserção da nossa lista de itens
  HomePage() {
    items.add(Item(title: "Supino Inclinado", done: true));
    items.add(Item(title: "Supino Reto", done: false));
    items.add(Item(title: "Desenvolvimento", done: true));
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Essa controller faz o controle de tudo que fizemos dentro da nossa caixa de texto
  var newTaskController = TextEditingController();

  void add() {
    //Uma pequena validação para que quando for
    //inserido um item em branco ele não inseria vazio na nossa To Do List
    if (newTaskController.text.isEmpty) return;
    //Sempre que formos alterar um estado na tela, temos que invocar o setState
    setState(() {
      //Aqui inserimos o que digitamos na nossa classe de item
      widget.items.add(Item(title: newTaskController.text, done: false));
      //Após a inserção a controller limpa o textbox que foi escrito
      newTaskController.clear();
    });
  }

  //Criação da função remove para remover o item
  void remove(int index) {
    //Sempre que formos alterar um estado na tela, temos que invocar o setState
    setState(() {
      widget.items.removeAt(index);
    });
  }

  @override
  //situação atual da aplicação muito usado para trocar de pagina
  Widget build(BuildContext context) {
    // Scaffold representa uma página
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          //Para referenciar a controller dentro do nosso TextForm instanciamos ela dentro do nosso TextFormField
          controller: newTaskController,

          //faz ao clicarmos na caixa texto aparecer o teclado para o usuario digitar
          //keyboardType: TextInputType.phone -> aparecer somente teclado
          keyboardType: TextInputType.text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
          ),
          decoration: const InputDecoration(
            //Coloca um titulo pra nossa label
            labelText: "Nova Tarefa",
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
      ),
      //ListViewBuilder serve para renderizar em tempo de execução os itens, ou seja a medida que vai
      //surgindo novos itens ele renderiza, ele não renderiza tudo de uma vez, isso faz com que a performance seja mais rapida
      //Basicamente ele vai construir nossa lista ai de acordo com o tamanho da nossa lista
      body: ListView.builder(
        //widget.items acessa a nossa lista que foi criada na nossa widget pai
        itemCount: widget.items.length,
        //contexto da aplicação atual, o index é qual o item do nosso array ele ta percorrendo
        itemBuilder: (BuildContext context, int index) {
          //trazendo o item atual em uma constante
          final item = widget.items[index];
          //Dismissible é quando nós deslizamos a linha do item para o lado para ela sumir da tela
          return Dismissible(
            //Esses 4 itens são obrigadorios na criação do checklisttile
            child: CheckboxListTile(
              title: Text(item.title),
              value: item.done,
              //Função que pode gerar algum evento ao você alterar o checkbox
              onChanged: (value) {
                //Só esta disponivel em statefull widgets, pois só conseguimos setar estado no statefull
                //o Set State diz para o flutter que item x mudou e ele builda pra nós ou seja recriar/redesenhar na tela
                //tudo o que a gente precisa alterar na tela depois que ela foi desenhada nós chamamos o set state
                setState(() {
                  item.done = value!;
                });
              },
            ),
            key: Key(item.title),
            //Container basicamente ocupa todo o espaço do item em que ele foi criado
            background: Container(
              color: Colors.red,
            ),
            //Ao fazer a ação de "jogar" o item para o lado ele ira chamar a função remove que criamos
            onDismissed: (direction) {
              remove(index);
            },
          );
        },
      ),
      //Cria um botão flutuante no canto da tela
      //Dentro dessa função nós temos o onPressed que é a função que diz o que vai ocorrer ao você clicar no botão
      //Na segunda linha temos o child que diz sobre o item que terá dentro do botão, ou seja o icone
      //Icons. => É um enumerador de icones que você tem acesso para inserir no seu projeto
      //Backgroud color define a cor do seu botão
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
