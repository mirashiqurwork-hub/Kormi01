import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const navy = Color(0xFF0A2342);
const navy2 = Color(0xFF122F57);
const gold = Color(0xFFC9A86A);
const gold2 = Color(0xFFD9BE8C);
const bg = Color(0xFFEEF2F6);
const ink = Color(0xFF1A2E4A);

void main(){ runApp(const KormiApp()); }

class KormiApp extends StatelessWidget{
  const KormiApp({super.key});
  @override Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title:'KORMI',
      theme: ThemeData(useMaterial3:true, scaffoldBackgroundColor:bg, fontFamily:'Roboto', colorScheme: ColorScheme.fromSeed(seedColor: navy, primary: navy, secondary: gold)),
      home: const BootScreen(),
    );
  }
}

// ---------- STORAGE ----------
class Store {
  static late SharedPreferences prefs;
  static List<Map<String,dynamic>> workers=[];
  static List<Map<String,dynamic>> attendance=[];
  static List<Map<String,dynamic>> production=[];
  static List<Map<String,dynamic>> breakdown=[];
  static List<Map<String,dynamic>> manpower=[];
  static List<Map<String,dynamic>> messages=[];
  static List<Map<String,dynamic>> alerts=[];
  static List<Map<String,dynamic>> companies=[];
  static Map<String,dynamic> currentUser={'card':'ADMIN','name':'Tariqul Islam','role':'Admin','unit':'Unit 1','shift':'Shift P/A'};
  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    workers = _load('workers', [
      {'card':'W-101','name':'Tariqul Islam','role':'Admin','unit':'Unit 1','shift':'Shift P/A','status':'Active','phone':'01700-000001'},
      {'card':'OFF-12','name':'Sajjad Hossain','role':'Officer','unit':'Unit 1','shift':'Shift P/A','status':'Active','phone':'01700-000012'},
      {'card':'W-102','name':'Md. Rahim Mia','role':'Worker','unit':'Unit 1','shift':'Shift P/A','status':'Active','phone':'01700-000002'},
      {'card':'W-103','name':'Fatema Begum','role':'Worker','unit':'Unit 2','shift':'Shift P/B','status':'Active','phone':'01700-000003'},
      {'card':'W-104','name':'Kamrul Hasan','role':'Worker','unit':'Unit 1','shift':'Shift P/A','status':'Active','phone':'01700-000004'},
      {'card':'W-105','name':'Nasrin Akter','role':'Worker','unit':'Unit 2','shift':'Shift P/C','status':'Active','phone':'01700-000005'},
      {'card':'W-106','name':'Rashedul Karim','role':'Worker','unit':'Unit 1','shift':'Shift P/A','status':'Pending','phone':'01700-000006'},
      {'card':'OFF-19','name':'Farhana Yasmin','role':'Officer','unit':'Unit 2','shift':'Shift P/B','status':'Pending','phone':'01700-000019'},
    ]);
    attendance = _load('attendance', []);
    production = _load('production', [
      {'unit':'Unit 1','machine':'RF-09','type':'C/D','output':'15570.7','shift':'P/A','date':'18/11/2026'},
      {'unit':'Unit 2','machine':'RF-01','type':'B/D','output':'3290.8','shift':'P/A','date':'18/11/2026'},
    ]);
    breakdown = _load('breakdown', [
      {'unit':'Unit 1','machine':'RF-14','type':'Ring Frame','issue':'Spindle belt tension drop','shift':'P/A','status':'Open'},
    ]);
    manpower = _load('manpower', [
      {'unit':'Unit 1','shift':'P/A','present':'42','total':'48','note':'2 absent, 4 off'},
    ]);
    messages = _load('messages', [
      {'name':'Engr. Mahmudul Hasan','last':'Great output. Please approve RF-14 maintenance...','time':'08:34','unread':'0'},
      {'name':'Md. Rahim Mia','last':'Assalamu Alaikum Sir, Shift P/A bobbin stock is ready near Bay 3.','time':'09:24','unread':'1'},
      {'name':'Sajjad Hossain','last':'Voice message (0:09)','time':'09:18','unread':'1'},
      {'name':'Unit 1 - Ring Frame Ops','last':'Sajjad: Checked RF-01 to RF-16. Average spindle s...','time':'09:12','unread':'1'},
    ]);
    alerts = _load('alerts', [
      {'title':'Production Summary Saved','desc':'Saved 6 machine output(s) ready to share.','time':'14:42'},
      {'title':'2 Pending Account Approvals','desc':'Rashedul Karim (W-106) and Farhana Yasmin (OFF-19) await Admin review.','time':'09:10'},
      {'title':'Ring Frame RF-14 Breakdown','desc':'Spindle belt tension drop reported on Unit 1 - Shift P/A.','time':'08:45'},
      {'title':'Weekly Shift Rotation Scheduled','desc':'P/A -> P/B -> P/C rotation scheduled for Sunday.','time':'Yesterday'},
    ]);
    companies = _load('companies', [
      {'name':'KORMI Spinning Mills Ltd.','code':'KSM-01','addr':'Gazipur Industrial Zone, Dhaka','night':'150'},
    ]);
  }
  static List<Map<String,dynamic>> _load(String k, List<Map<String,dynamic>> def){
    final s = prefs.getString(k); if(s==null){ prefs.setString(k, jsonEncode(def)); return List<Map<String,dynamic>>.from(def); }
    try{ return List<Map<String,dynamic>>.from(jsonDecode(s).map((e)=>Map<String,dynamic>.from(e))); }catch(_){ return def; }
  }
  static Future<void> save(String k, List<Map<String,dynamic>> v) async { await prefs.setString(k, jsonEncode(v)); }
}

class BootScreen extends StatefulWidget{ const BootScreen({super.key}); @override State<BootScreen> createState()=>_Boot(); }
class _Boot extends State<BootScreen>{
  @override void initState(){ super.initState(); _go(); }
  Future<void> _go() async { await Store.init(); if(!mounted) return; Navigator.pushReplacement(context, MaterialPageRoute(builder:(_)=>const LoginScreen())); }
  @override Widget build(BuildContext context){ return const Scaffold(backgroundColor: navy, body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children:[Text('KORMI', style:TextStyle(color: gold, fontSize:42, fontWeight: FontWeight.w900, letterSpacing:4)), SizedBox(height:8), Text('Spinning Mill Workforce & Production Suite', style:TextStyle(color: Colors.white70))]))); }
}

// ---------- WIDGETS ----------
Widget goldBtn(String t, VoidCallback onTap)=> SizedBox(width:double.infinity, height:52, child: ElevatedButton(onPressed:onTap, style: ElevatedButton.styleFrom(backgroundColor: navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), child: Text(t, style: const TextStyle(fontWeight: FontWeight.w800, fontSize:16))));
Widget field(TextEditingController c, String hint, {bool pass=false, TextInputType type=TextInputType.text, Widget? suffix})=> TextField(controller:c, obscureText:pass, keyboardType:type, decoration: InputDecoration(hintText:hint, filled:true, fillColor: Colors.white, suffixIcon: suffix, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)), contentPadding: const EdgeInsets.symmetric(horizontal:14, vertical:14)));
Widget cardBox(Widget child)=> Container(width:double.infinity, padding: const EdgeInsets.all(16), margin: const EdgeInsets.only(bottom:12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow:[BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius:10, offset: const Offset(0,4))]), child: child);
Widget topBar(BuildContext ctx, String title)=> Container(color: navy, padding: const EdgeInsets.fromLTRB(12,10,16,14), child: Row(children:[IconButton(onPressed:()=>Navigator.pop(ctx), icon: const Icon(Icons.arrow_back, color: gold2)), Text(title, style: const TextStyle(color: gold2, fontSize:18, fontWeight: FontWeight.w800)), const Spacer(), Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700))]));

// ---------- LOGIN ----------
class LoginScreen extends StatefulWidget{ const LoginScreen({super.key}); @override State<LoginScreen> createState()=>_Login(); }
class _Login extends State<LoginScreen>{
  final idC=TextEditingController(); final pwC=TextEditingController(); bool show=false; bool isRegister=false;
  final nameC=TextEditingController(); final compC=TextEditingController(text:'KORMI Spinning Mills Ltd.');
  void _login(){
    if(idC.text.trim().isEmpty || pwC.text.isEmpty){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Card ID ar Password dao'))); return; }
    if(idC.text.trim().toUpperCase()=='ADMIN' && pwC.text=='ADMIN123'){ Store.currentUser={'card':'ADMIN','name':'Tariqul Islam','role':'Admin','unit':'Unit 1','shift':'Shift P/A'}; _enter(); return; }
    final found = Store.workers.where((w)=> w['card'].toString().toUpperCase()==idC.text.trim().toUpperCase()).toList();
    if(found.isEmpty){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ei Card ID paoa jay nai. Register koro.'))); return; }
    if(found.first['status']=='Pending'){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account Pending - Admin approve korle dhukte parba'))); return; }
    Store.currentUser={'card':found.first['card'],'name':found.first['name'],'role':found.first['role'],'unit':found.first['unit'],'shift':found.first['shift']};
    _enter();
  }
  void _register(){
    if(nameC.text.isEmpty || idC.text.isEmpty || pwC.text.isEmpty){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo chara - Name, Card, Password must'))); return; }
    Store.workers.add({'card':idC.text.trim(),'name':nameC.text.trim(),'role':'Worker','unit':'Unit 1','shift':'Shift P/A','status':'Pending','phone':''});
    Store.save('workers', Store.workers);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Register hoise - Pending. Admin approve korbe.')));
    setState(()=> isRegister=false);
  }
  void _enter(){ Navigator.pushReplacement(context, MaterialPageRoute(builder:(_)=>const MainScreen())); }
  @override Widget build(BuildContext context){
    return Scaffold(backgroundColor: navy, body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(children:[
      const SizedBox(height:20), Container(width:78,height:78, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: const Center(child: Text('K', style: TextStyle(fontSize:44, fontWeight: FontWeight.w900, color: navy)))),
      const SizedBox(height:14), const Text('KORMI', style: TextStyle(color: gold, fontSize:34, fontWeight: FontWeight.w900, letterSpacing:6)), const Text('Spinning Mill Workforce & Production Suite', style: TextStyle(color: Colors.white70), textAlign: TextAlign.center),
      const SizedBox(height:22),
      Container(decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(14)), padding: const EdgeInsets.all(4), child: Row(children:[
        Expanded(child: GestureDetector(onTap:()=>setState(()=>isRegister=false), child: Container(padding: const EdgeInsets.symmetric(vertical:10), decoration: BoxDecoration(color: !isRegister? Colors.white: Colors.transparent, borderRadius: BorderRadius.circular(10)), child: Text('Sign In', textAlign: TextAlign.center, style: TextStyle(color: !isRegister? navy: Colors.white, fontWeight: FontWeight.w800))))),
        Expanded(child: GestureDetector(onTap:()=>setState(()=>isRegister=true), child: Container(padding: const EdgeInsets.symmetric(vertical:10), decoration: BoxDecoration(color: isRegister? Colors.white: Colors.transparent, borderRadius: BorderRadius.circular(10)), child: Text('Register', textAlign: TextAlign.center, style: TextStyle(color: isRegister? navy: Colors.white, fontWeight: FontWeight.w800))))),
      ])),
      const SizedBox(height:18),
      Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
        if(isRegister) ...[field(nameC,'Full Name'), const SizedBox(height:12), field(compC,'Company - KORMI Spinning Mills Ltd.'), const SizedBox(height:12)],
        field(idC, isRegister? 'Card Number / Email - Login ID':'Worker Card ID / Admin ID'),
        const SizedBox(height:12),
        field(pwC,'Password / PIN', pass:!show, suffix: IconButton(icon: Icon(show? Icons.visibility_off: Icons.visibility), onPressed:()=>setState(()=>show=!show))),
        const SizedBox(height:16),
        SizedBox(width:double.infinity, height:52, child: ElevatedButton(onPressed: isRegister? _register: _login, style: ElevatedButton.styleFrom(backgroundColor: navy, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), child: Text(isRegister? 'Register - Pending for Approval':'Sign In to Mill Workspace', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)))),
        const SizedBox(height:12), const Center(child: Text('Default Admin: ADMIN / ADMIN123', style: TextStyle(color: Colors.grey, fontSize:12))),
      ])),
    ]))));
  }
}

// ---------- MAIN ----------
class MainScreen extends StatefulWidget{ const MainScreen({super.key}); @override State<MainScreen> createState()=>_Main(); }
class _Main extends State<MainScreen>{
  int idx=0;
  final pages=[const DashboardScreen(), const MessagesScreen(), const AlertsScreen(), const AdminScreen()];
  @override Widget build(BuildContext context){
    return Scaffold(body: pages[idx], bottomNavigationBar: Container(color: navy, padding: const EdgeInsets.symmetric(vertical:8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children:[
      _nav(0, Icons.home, 'Home'), _nav(1, Icons.chat_bubble_outline, 'Chat'), _nav(2, Icons.notifications_none, 'Alerts'), _nav(3, Icons.shield_outlined, 'Admin'),
    ])));
  }
  Widget _nav(int i, IconData ic, String l)=> GestureDetector(onTap:()=>setState(()=>idx=i), child: Column(children:[Icon(ic, color: idx==i? gold: Colors.white70), Text(l, style: TextStyle(color: idx==i? gold: Colors.white70, fontWeight: FontWeight.w700))]));
}

// ---------- DASHBOARD ----------
class DashboardScreen extends StatefulWidget{ const DashboardScreen({super.key}); @override State<DashboardScreen> createState()=>_Dash(); }
class _Dash extends State<DashboardScreen>{
  @override Widget build(BuildContext context){
    final u = Store.currentUser;
    final mods=[
      {'t':'Workers','s':'${Store.workers.length} Total','i':Icons.group,'p':()=>Navigator.push(context, MaterialPageRoute(builder:(_)=>const WorkersScreen()))},
      {'t':'Attendance','s':'Today Mark','i':Icons.fingerprint,'p':()=>Navigator.push(context, MaterialPageRoute(builder:(_)=>const AttendanceScreen()))},
      {'t':'Manpower','s':'Shift Wise','i':Icons.people,'p':()=>Navigator.push(context, MaterialPageRoute(builder:(_)=>const ManpowerScreen()))},
      {'t':'Production','s':'18,861 kg Today','i':Icons.factory,'p':()=>Navigator.push(context, MaterialPageRoute(builder:(_)=>const ProductionScreen()))},
      {'t':'Breakdown','s':'1 Open','i':Icons.build,'p':()=>Navigator.push(context, MaterialPageRoute(builder:(_)=>const BreakdownScreen()))},
      {'t':'Messages','s':'3 Unread','i':Icons.message,'p':()=>Navigator.push(context, MaterialPageRoute(builder:(_)=>const MessagesScreen()))},
      {'t':'Location','s':'GPS Check-In','i':Icons.location_on,'p':()=>Navigator.push(context, MaterialPageRoute(builder:(_)=>const LocationScreen()))},
      {'t':'Admin','s':'Control Panel','i':Icons.admin_panel_settings,'p':()=>Navigator.push(context, MaterialPageRoute(builder:(_)=>const AdminScreen()))},
    ];
    return Scaffold(backgroundColor: bg, body: SafeArea(child: Column(children:[
      Container(color: navy, padding: const EdgeInsets.all(18), child: Column(children:[
        Row(children:[Container(width:48,height:48, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: const Center(child: Text('TI', style: TextStyle(fontWeight: FontWeight.w900, color: navy))), const SizedBox(width:12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text('${u['name']} - ${u['role']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize:17)), Text('${u['shift']} - ${u['unit']}', style: const TextStyle(color: gold2))])), IconButton(onPressed:()=>Navigator.push(context, MaterialPageRoute(builder:(_)=>const ProfileScreen())), icon: const Icon(Icons.edit, color: gold2))]),
        const SizedBox(height:14), Row(children:[Expanded(child: _stat('Workers','${Store.workers.length}')), Expanded(child: _stat('Present','42')), Expanded(child: _stat('Production','18.8k kg'))]),
      ])),
      Expanded(child: GridView.builder(padding: const EdgeInsets.all(14), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2, crossAxisSpacing:12, mainAxisSpacing:12, childAspectRatio:1.25), itemCount: mods.length, itemBuilder:(_,i){ final m=mods[i]; return GestureDetector(onTap:(){ (m['p'] as Function)(); setState((){}); }, child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow:[BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius:8)]), padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(12)), child: Icon(m['i'] as IconData, color: gold)), const Spacer(), Text(m['t'] as String, style: const TextStyle(fontWeight: FontWeight.w900, fontSize:16, color: ink)), Text(m['s'] as String, style: const TextStyle(color: Colors.grey))]))); })),
    ])));
  }
  Widget _stat(String l, String v)=> Container(margin: const EdgeInsets.only(right:8), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(12)), child: Column(children:[Text(v, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)), Text(l, style: const TextStyle(color: Colors.white70, fontSize:12))]));
}

// ---------- WORKERS ----------
class WorkersScreen extends StatefulWidget{ const WorkersScreen({super.key}); @override State<WorkersScreen> createState()=>_Workers(); }
class _Workers extends State<WorkersScreen>{
  String q=''; String tab='All';
  final nameC=TextEditingController(); final cardC=TextEditingController(); final phoneC=TextEditingController();
  @override Widget build(BuildContext context){
    final list = Store.workers.where((w){ if(tab=='Pending' && w['status']!='Pending') return false; if(tab=='Active' && w['status']!='Active') return false; if(q.isNotEmpty && !w['name'].toString().toLowerCase().contains(q.toLowerCase()) && !w['card'].toString().toLowerCase().contains(q.toLowerCase())) return false; return true; }).toList();
    return Scaffold(backgroundColor: bg, body: SafeArea(child: Column(children:[
      topBar(context,'Workers'),
      Padding(padding: const EdgeInsets.all(14), child: Column(children:[
        TextField(onChanged:(v)=>setState(()=>q=v), decoration: InputDecoration(hintText:'Search Worker / Card ID', prefixIcon: const Icon(Icons.search), filled:true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
        const SizedBox(height:10), Row(children:[for(final t in ['All','Active','Pending']) Expanded(child: GestureDetector(onTap:()=>setState(()=>tab=t), child: Container(margin: const EdgeInsets.only(right:6), padding: const EdgeInsets.symmetric(vertical:10), decoration: BoxDecoration(color: tab==t? navy: Colors.white, borderRadius: BorderRadius.circular(10)), child: Text(t, textAlign: TextAlign.center, style: TextStyle(color: tab==t? Colors.white: ink, fontWeight: FontWeight.w700)))))]),
      ])),
      Expanded(child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal:14), itemCount: list.length, itemBuilder:(_,i){ final w=list[i]; return cardBox(Row(children:[CircleAvatar(backgroundColor: navy, child: Text(w['name'].toString().substring(0,1), style: const TextStyle(color: gold))), const SizedBox(width:12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text(w['name'], style: const TextStyle(fontWeight: FontWeight.w800)), Text('${w['card']} • ${w['role']} • ${w['unit']} • ${w['shift']}', style: const TextStyle(color: Colors.grey, fontSize:12))])), Container(padding: const EdgeInsets.symmetric(horizontal:10, vertical:5), decoration: BoxDecoration(color: w['status']=='Active'? Colors.green.shade100: Colors.orange.shade100, borderRadius: BorderRadius.circular(20)), child: Text(w['status'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize:12))), if(w['status']=='Pending') ...[const SizedBox(width:6), GestureDetector(onTap:(){ setState(()=> w['status']='Active'); Store.save('workers', Store.workers); }, child: const Icon(Icons.check_circle, color: Colors.green)), GestureDetector(onTap:(){ setState(()=> Store.workers.remove(w)); Store.save('workers', Store.workers); }, child: const Icon(Icons.cancel, color: Colors.red))]])); })),
      Padding(padding: const EdgeInsets.all(14), child: goldBtn('+ Add Worker', ()=> _addDialog())),
    ])));
  }
  void _addDialog(){ nameC.clear(); cardC.clear(); phoneC.clear(); showDialog(context: context, builder:(_)=> AlertDialog(title: const Text('Add Worker'), content: Column(mainAxisSize: MainAxisSize.min, children:[field(nameC,'Full Name'), const SizedBox(height:10), field(cardC,'Card Number - e.g. W-107'), const SizedBox(height:10), field(phoneC,'Phone', type: TextInputType.phone)]), actions:[TextButton(onPressed:()=>Navigator.pop(context), child: const Text('Cancel')), ElevatedButton(onPressed:(){ if(nameC.text.isEmpty||cardC.text.isEmpty){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Name + Card must'))); return; } setState(()=> Store.workers.add({'card':cardC.text.trim(),'name':nameC.text.trim(),'role':'Worker','unit':'Unit 1','shift':'Shift P/A','status':'Active','phone':phoneC.text})); Store.save('workers', Store.workers); Navigator.pop(context); }, child: const Text('Add'))])); }
}

// ---------- ATTENDANCE + OT ----------
class AttendanceScreen extends StatefulWidget{ const AttendanceScreen({super.key}); @override State<AttendanceScreen> createState()=>_Att(); }
class _Att extends State<AttendanceScreen>{
  String date='18/11/2026'; Map<String,String> marks={}; final otCard=TextEditingController(); final otH=TextEditingController(); final otR=TextEditingController(text:'50');
  @override Widget build(BuildContext context){
    return Scaffold(backgroundColor: bg, body: SafeArea(child: SingleChildScrollView(child: Column(children:[
      topBar(context,'Attendance'),
      Padding(padding: const EdgeInsets.all(14), child: Column(children:[
        cardBox(Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Row(children:[const Expanded(child: Text('Date', style: TextStyle(fontWeight: FontWeight.w800))), Text(date, style: const TextStyle(fontWeight: FontWeight.w800))]), const SizedBox(height:10), const Text('Tap kore Present / Absent / Off dao - auto save hobe'), const SizedBox(height:10), ...Store.workers.map((w)=> Padding(padding: const EdgeInsets.only(bottom:8), child: Row(children:[Expanded(child: Text('${w['name']} (${w['card']})', style: const TextStyle(fontWeight: FontWeight.w700))), for(final s in ['P','A','Off']) GestureDetector(onTap:()=>setState(()=> marks[w['card']]=s), child: Container(margin: const EdgeInsets.only(left:6), padding: const EdgeInsets.symmetric(horizontal:12, vertical:7), decoration: BoxDecoration(color: marks[w['card']]==s? navy: Colors.grey.shade200, borderRadius: BorderRadius.circular(20)), child: Text(s=='P'? 'Present': s=='A'? 'Absent':'Off Day', style: TextStyle(color: marks[w['card']]==s? Colors.white: ink, fontWeight: FontWeight.w700, fontSize:12))))]))])),
        cardBox(Column(crossAxisAlignment: CrossAxisAlignment.start, children:[const Text('Log Overtime & Night Bill', style: TextStyle(fontWeight: FontWeight.w900, fontSize:17)), const SizedBox(height:12), field(otCard,'Card ID - e.g. W-101'), const SizedBox(height:10), Row(children:[Expanded(child: field(otH,'OT Hours', type: TextInputType.number)), const SizedBox(width:10), Expanded(child: field(otR,'Rate / hr', type: TextInputType.number))]), const SizedBox(height:12), goldBtn('Save Overtime Entry', (){ if(otCard.text.isEmpty||otH.text.isEmpty){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Card + Hours dao'))); return; } final total = (double.tryParse(otH.text)??0)*(double.tryParse(otR.text)??0); Store.attendance.add({'card':otCard.text,'ot':otH.text,'total':total.toString(),'date':date}); Store.save('attendance', Store.attendance); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OT Saved - Total $total'))); otCard.clear(); otH.clear(); })])),
        if(Store.attendance.isNotEmpty) cardBox(Column(crossAxisAlignment: CrossAxisAlignment.start, children:[const Text('Saved OT', style: TextStyle(fontWeight: FontWeight.w800)), ...Store.attendance.map((e)=> Padding(padding: const EdgeInsets.only(top:6), child: Text('${e['card']} - ${e['ot']} hr - ${e['total']}')))])),
      ])),
    ]))));
  }
}

// ---------- PRODUCTION ----------
class ProductionScreen extends StatefulWidget{ const ProductionScreen({super.key}); @override State<ProductionScreen> createState()=>_Prod(); }
class _Prod extends State<ProductionScreen>{
  String unit='Unit 1'; String type='C/D'; String shift='P/A';
  final machineC=TextEditingController(text:'RF-09'); final outC=TextEditingController(); final rpmC=TextEditingController(text:'16500'); final tpiC=TextEditingController(text:'19.5'); final countC=TextEditingController(text:'30'); final spinC=TextEditingController(text:'1000'); final effC=TextEditingController(text:'92');
  double calc(){ final rpm=double.tryParse(rpmC.text)??0; final tpi=double.tryParse(tpiC.text)??0; final cnt=double.tryParse(countC.text)??1; final sp=double.tryParse(spinC.text)??0; final eff=double.tryParse(effC.text)??0; if(tpi==0||cnt==0) return 0; return (rpm*60*8*sp*eff/100)/(tpi*840*cnt)*0.453592; }
  @override Widget build(BuildContext context){
    return Scaffold(backgroundColor: bg, body: SafeArea(child: SingleChildScrollView(child: Column(children:[
      topBar(context,'Production'),
      Padding(padding: const EdgeInsets.all(14), child: Column(children:[
        Row(children:[Expanded(child: cardBox(Column(children:[const Text('Unit 1 Total'), const Text('15,570.7 kg', style: TextStyle(fontWeight: FontWeight.w900, fontSize:18))]))), const SizedBox(width:10), Expanded(child: cardBox(Column(children:[const Text('Unit 2 Total'), const Text('3,290.8 kg', style: TextStyle(fontWeight: FontWeight.w900, fontSize:18))])))]),
        cardBox(Column(crossAxisAlignment: CrossAxisAlignment.start, children:[const Text('Log Machine Output', style: TextStyle(fontWeight: FontWeight.w900, fontSize:17)), const SizedBox(height:12), Row(children:[Expanded(child: DropdownButtonFormField<String>(value:unit, items: const [DropdownMenuItem(value:'Unit 1', child: Text('Unit 1')), DropdownMenuItem(value:'Unit 2', child: Text('Unit 2'))], onChanged:(v)=>setState(()=>unit=v!))), const SizedBox(width:10), Expanded(child: DropdownButtonFormField<String>(value:type, items: const [DropdownMenuItem(value:'C/D', child: Text('C/D')), DropdownMenuItem(value:'B/D', child: Text('B/D')), DropdownMenuItem(value:'F/D', child: Text('F/D')), DropdownMenuItem(value:'S/F', child: Text('S/F')), DropdownMenuItem(value:'R/F', child: Text('R/F')), DropdownMenuItem(value:'L/C', child: Text('L/C'))], onChanged:(v)=>setState(()=>type=v!)))]), const SizedBox(height:10), field(machineC,'Machine - e.g. RF-09'), const SizedBox(height:10), field(outC,'Output kg', type: TextInputType.number), const SizedBox(height:12), goldBtn('Save & Generate Share Format', (){ if(outC.text.isEmpty){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Output dao'))); return; } setState(()=> Store.production.add({'unit':unit,'machine':machineC.text,'type':type,'output':outC.text,'shift':shift,'date':'18/11/2026'})); Store.save('production', Store.production); outC.clear(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Production Saved'))); })])),
        cardBox(Column(crossAxisAlignment: CrossAxisAlignment.start, children:[const Text('Spinning Calculator - Ring', style: TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height:10), field(rpmC,'Spindle RPM', type: TextInputType.number), const SizedBox(height:8), field(tpiC,'TPI', type: TextInputType.number), const SizedBox(height:8), field(countC,'Yarn Count', type: TextInputType.number), const SizedBox(height:8), field(spinC,'Spindles', type: TextInputType.number), const SizedBox(height:8), field(effC,'Efficiency %', type: TextInputType.number), const SizedBox(height:12), Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)), child: Row(children:[const Text('8-Hour Shift Output: ', style: TextStyle(fontWeight: FontWeight.w700)), Text('${calc().toStringAsFixed(2)} kg/shift', style: const TextStyle(fontWeight: FontWeight.w900, color: navy))])), const SizedBox(height:10), goldBtn('Calculate', ()=> setState((){}))])),
        cardBox(Column(crossAxisAlignment: CrossAxisAlignment.start, children:[const Text('Saved Machine Outputs', style: TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height:8), ...Store.production.map((e)=> Padding(padding: const EdgeInsets.only(bottom:6), child: Text('${e['unit']} - ${e['machine']} - ${e['type']} - ${e['output']} kg - ${e['shift']}'))), const SizedBox(height:10), goldBtn('Copy Share Format', (){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Share Format Copied - WhatsApp e paste koro'))); })])),
      ])),
    ]))));
  }
}

// ---------- MANPOWER ----------
class ManpowerScreen extends StatefulWidget{ const ManpowerScreen({super.key}); @override State<ManpowerScreen> createState()=>_Man(); }
class _Man extends State<ManpowerScreen>{
  final unitC=TextEditingController(text:'Unit 1'); final shiftC=TextEditingController(text:'P/A'); final presentC=TextEditingController(); final totalC=TextEditingController(); final noteC=TextEditingController();
  @override Widget build(BuildContext context){ return Scaffold(backgroundColor: bg, body: SafeArea(child: SingleChildScrollView(child: Column(children:[ topBar(context,'Manpower'), Padding(padding: const EdgeInsets.all(14), child: Column(children:[ cardBox(Column(crossAxisAlignment: CrossAxisAlignment.start, children:[const Text('Add Manpower Entry', style: TextStyle(fontWeight: FontWeight.w900, fontSize:17)), const SizedBox(height:10), field(unitC,'Unit'), const SizedBox(height:10), field(shiftC,'Shift - P/A / P/B / P/C'), const SizedBox(height:10), Row(children:[Expanded(child: field(presentC,'Present', type: TextInputType.number)), const SizedBox(width:10), Expanded(child: field(totalC,'Total', type: TextInputType.number))]), const SizedBox(height:10), field(noteC,'Note'), const SizedBox(height:12), goldBtn('Save Manpower', (){ if(presentC.text.isEmpty||totalC.text.isEmpty){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Present + Total dao'))); return; } setState(()=> Store.manpower.add({'unit':unitC.text,'shift':shiftC.text,'present':presentC.text,'total':totalC.text,'note':noteC.text})); Store.save('manpower', Store.manpower); presentC.clear(); totalC.clear(); noteC.clear(); })])), ...Store.manpower.map((e)=> cardBox(Row(children:[Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text('${e['unit']} - Shift ${e['shift']}', style: const TextStyle(fontWeight: FontWeight.w800)), Text(e['note']??'', style: const TextStyle(color: Colors.grey))])), Text('${e['present']}/${e['total']}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize:18))])) ])) ])))); }
}

// ---------- BREAKDOWN ----------
class BreakdownScreen extends StatefulWidget{ const BreakdownScreen({super.key}); @override State<BreakdownScreen> createState()=>_Br(); }
class _Br extends State<BreakdownScreen>{
  final machineC=TextEditingController(); final issueC=TextEditingController(); String type='Ring Frame'; String unit='Unit 1';
  @override Widget build(BuildContext context){ return Scaffold(backgroundColor: bg, body: SafeArea(child: SingleChildScrollView(child: Column(children:[ topBar(context,'Breakdown'), Padding(padding: const EdgeInsets.all(14), child: Column(children:[ cardBox(Column(crossAxisAlignment: CrossAxisAlignment.start, children:[const Text('Report Machine Breakdown', style: TextStyle(fontWeight: FontWeight.w900, fontSize:17)), const SizedBox(height:10), field(machineC,'Machine - e.g. RF-14'), const SizedBox(height:10), field(issueC,'Issue - e.g. Spindle belt tension drop'), const SizedBox(height:12), goldBtn('Report Breakdown', (){ if(machineC.text.isEmpty||issueC.text.isEmpty){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Machine + Issue dao'))); return; } setState(()=> Store.breakdown.add({'unit':unit,'machine':machineC.text,'type':type,'issue':issueC.text,'shift':'P/A','status':'Open'})); Store.save('breakdown', Store.breakdown); machineC.clear(); issueC.clear(); })])), const Align(alignment: Alignment.centerLeft, child: Text('Breakdown Log', style: TextStyle(fontWeight: FontWeight.w900, fontSize:17))), const SizedBox(height:8), ...Store.breakdown.map((e)=> cardBox(Row(children:[Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text('${e['machine']} - ${e['type']}', style: const TextStyle(fontWeight: FontWeight.w800)), Text(e['issue'], style: const TextStyle(color: Colors.grey)), Text('${e['unit']} - ${e['shift']}')])), Column(children:[Container(padding: const EdgeInsets.symmetric(horizontal:10, vertical:5), decoration: BoxDecoration(color: e['status']=='Open'? Colors.red.shade100: Colors.green.shade100, borderRadius: BorderRadius.circular(20)), child: Text(e['status'])), if(e['status']=='Open') TextButton(onPressed:()=>setState(()=> e['status']='Fixed'), child: const Text('Mark Fixed'))])])) ])) ])))); }
}

// ---------- MESSAGES ----------
class MessagesScreen extends StatefulWidget{ const MessagesScreen({super.key}); @override State<MessagesScreen> createState()=>_Msg(); }
class _Msg extends State<MessagesScreen>{
  @override Widget build(BuildContext context){ return Scaffold(backgroundColor: bg, body: SafeArea(child: Column(children:[ topBar(context,'Messages'), Expanded(child: ListView.builder(padding: const EdgeInsets.all(14), itemCount: Store.messages.length, itemBuilder:(_,i){ final m=Store.messages[i]; return GestureDetector(onTap:()=> Navigator.push(context, MaterialPageRoute(builder:(_)=> ChatDetailScreen(name: m['name']))), child: cardBox(Row(children:[CircleAvatar(backgroundColor: navy, child: Text(m['name'].toString().split(' ').map((e)=>e[0]).take(2).join(), style: const TextStyle(color: gold))), const SizedBox(width:12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text(m['name'], style: const TextStyle(fontWeight: FontWeight.w800)), Text(m['last'], maxLines:1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey))])), Text(m['time'], style: const TextStyle(color: Colors.grey, fontSize:12)), if(m['unread']!='0') Container(margin: const EdgeInsets.only(left:8), padding: const EdgeInsets.all(6), decoration: const BoxDecoration(color: gold, shape: BoxShape.circle), child: Text(m['unread'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800))) ]))); })) ]))); }
}
class ChatDetailScreen extends StatefulWidget{ final String name; const ChatDetailScreen({super.key, required this.name}); @override State<ChatDetailScreen> createState()=>_Chat(); }
class _Chat extends State<ChatDetailScreen>{
  final msgC=TextEditingController(); List<String> chats=['Assalamu Alaikum Sir, Shift P/A bobbin stock is ready near Bay 3.'];
  @override Widget build(BuildContext context){ return Scaffold(backgroundColor: bg, body: SafeArea(child: Column(children:[ topBar(context, widget.name), Expanded(child: ListView.builder(padding: const EdgeInsets.all(14), itemCount: chats.length, itemBuilder:(_,i)=> Align(alignment: Alignment.centerLeft, child: Container(padding: const EdgeInsets.all(12), margin: const EdgeInsets.only(bottom:8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)), child: Text(chats[i]))))), Padding(padding: const EdgeInsets.all(12), child: Row(children:[Expanded(child: field(msgC,'Message')), const SizedBox(width:8), CircleAvatar(backgroundColor: navy, child: IconButton(icon: const Icon(Icons.send, color: Colors.white), onPressed:(){ if(msgC.text.isEmpty) return; setState(()=> chats.add(msgC.text)); msgC.clear(); }))])) ]))); }
}

// ---------- LOCATION ----------
class LocationScreen extends StatelessWidget{ const LocationScreen({super.key}); @override Widget build(BuildContext context){
  final list=[{'n':'Tariqul Islam','a':'Gazipur Executive Quarters, Dhaka','lat':'23.9999','lon':'90.4283'},{'n':'Engr. Mahmudul Hasan','a':'Uttara Sector 11, Dhaka','lat':'23.8759','lon':'90.3795'},{'n':'Sajjad Hossain','a':'Konabari, Gazipur','lat':'24.0085','lon':'90.3318'}];
  return Scaffold(backgroundColor: bg, body: SafeArea(child: Column(children:[ topBar(context,'Location'), Padding(padding: const EdgeInsets.all(14), child: cardBox(Row(children:[const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text('Worker GPS Check-In', style: TextStyle(fontWeight: FontWeight.w900, fontSize:17)), Text('Tariqul Islam (ADMIN)')])), ElevatedButton(onPressed:(){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('GPS Updated - Gazipur'))); }, style: ElevatedButton.styleFrom(backgroundColor: navy), child: const Text('Update My GPS', style: TextStyle(color: Colors.white)))]))), Expanded(child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal:14), itemCount: list.length, itemBuilder:(_,i){ final e=list[i]; return cardBox(Row(children:[Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text(e['n']!, style: const TextStyle(fontWeight: FontWeight.w800)), Text(e['a']!, style: const TextStyle(color: Colors.grey))])), Column(children:[Text(e['lat']!, style: const TextStyle(fontWeight: FontWeight.w800)), Text(e['lon']!, style: const TextStyle(color: Colors.grey))])])); })) ]))); }
}

// ---------- ADMIN ----------
class AdminScreen extends StatefulWidget{ const AdminScreen({super.key}); @override State<AdminScreen> createState()=>_Admin(); }
class _Admin extends State<AdminScreen>{
  String tab='Shifts'; String rotationDay='SUNDAY'; final compName=TextEditingController(); final compCode=TextEditingController(text:'KSM-02'); final compNight=TextEditingController(text:'180');
  @override Widget build(BuildContext context){
    final tabs=['Shifts','Access','Mills','Backup','Audit'];
    return Scaffold(backgroundColor: bg, body: SafeArea(child: Column(children:[
      topBar(context,'Admin'),
      Padding(padding: const EdgeInsets.all(12), child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children:[for(final t in tabs) GestureDetector(onTap:()=>setState(()=>tab=t), child: Container(margin: const EdgeInsets.only(right:6), padding: const EdgeInsets.symmetric(horizontal:16, vertical:10), decoration: BoxDecoration(color: tab==t? Colors.white: Colors.transparent, borderRadius: BorderRadius.circular(10)), child: Text(t, style: TextStyle(fontWeight: FontWeight.w700, color: tab==t? navy: Colors.grey))))]))),
      Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(14), child: Column(children:[
        if(tab=='Shifts') cardBox(Column(crossAxisAlignment: CrossAxisAlignment.start, children:[const Text('Auto Shift Rotation (P/A -> P/B -> P/C)', style: TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height:12), const Text('Scheduled Weekly Rotation Day'), const SizedBox(height:8), DropdownButtonFormField<String>(value:rotationDay, items: const [DropdownMenuItem(value:'SUNDAY', child: Text('SUNDAY')), DropdownMenuItem(value:'MONDAY', child: Text('MONDAY')), DropdownMenuItem(value:'FRIDAY', child: Text('FRIDAY'))], onChanged:(v)=>setState(()=>rotationDay=v!), decoration: InputDecoration(filled:true, fillColor: bg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))), const SizedBox(height:12), goldBtn('Rotate Active Shifts Now', (){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Shift Rotated - Next: $rotationDay'))); })])),
        if(tab=='Access') cardBox(Column(crossAxisAlignment: CrossAxisAlignment.start, children:[const Text('Module Access Control', style: TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height:10), const Text('Sajjad Hossain (OFF-12 - Officer)'), const SizedBox(height:10), Wrap(spacing:8, runSpacing:8, children:[for(final m in ['Workers','Attendance','Manpower','Production','Breakdown','Messages','Location']) Container(padding: const EdgeInsets.symmetric(horizontal:12, vertical:8), decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(10)), child: Text('$m - On', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)))]), const SizedBox(height:12), Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(12)), child: const Row(children:[Expanded(child: Text('Share Production / Breakdown / Manpower', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))), Text('Allowed', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900))]))])),
        if(tab=='Mills') Column(children:[ ...Store.companies.map((c)=> cardBox(Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text(c['name'], style: const TextStyle(fontWeight: FontWeight.w900)), Text('${c['code']} - ${c['addr']}'), const SizedBox(height:8), Row(children:[const Text('Night Bill Rate (/night)'), const Spacer(), Text(c['night'], style: const TextStyle(fontWeight: FontWeight.w900))])])) , cardBox(Column(crossAxisAlignment: CrossAxisAlignment.start, children:[const Text('Add New Spinning Mill', style: TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height:10), field(compName,'Company Name (e.g. Padma Spinning Unit-2)'), const SizedBox(height:10), Row(children:[Expanded(child: field(compCode,'Code')), const SizedBox(width:10), Expanded(child: field(compNight,'Night Rate', type: TextInputType.number))]), const SizedBox(height:12), goldBtn('Add Company', (){ if(compName.text.isEmpty){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Company Name dao'))); return; } setState(()=> Store.companies.add({'name':compName.text,'code':compCode.text,'addr':'Gazipur','night':compNight.text})); Store.save('companies', Store.companies); compName.clear(); })]))]),
        if(tab=='Backup') cardBox(Column(children:[const Text('Backup & Restore', style: TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height:10), goldBtn('Backup Now', (){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup Saved - Local'))); }), const SizedBox(height:10), goldBtn('Export All Data', (){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Export Ready - Share koro'))); })])),
        if(tab=='Audit') Column(children:[ ...Store.alerts.map((a)=> cardBox(Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Row(children:[Expanded(child: Text(a['title'], style: const TextStyle(fontWeight: FontWeight.w800))), Text(a['time'], style: const TextStyle(color: Colors.grey, fontSize:12))]), Text(a['desc'], style: const TextStyle(color: Colors.grey))])) )]),
        if(tab=='Shifts'||tab=='Access'||tab=='Mills') cardBox(Column(crossAxisAlignment: CrossAxisAlignment.start, children:[const Text('Pending Approvals', style: TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height:8), ...Store.workers.where((w)=>w['status']=='Pending').map((w)=> Row(children:[Expanded(child: Text('${w['name']} (${w['card']})')), TextButton(onPressed:()=>setState(()=> w['status']='Active'), child: const Text('Approve')), TextButton(onPressed:()=>setState(()=> Store.workers.remove(w)), child: const Text('Reject', style: TextStyle(color: Colors.red)))])), if(Store.workers.where((w)=>w['status']=='Pending').isEmpty) const Text('Kono pending nai') ])),
      ]))),
    ])));
  }
}

// ---------- ALERTS + PROFILE ----------
class AlertsScreen extends StatelessWidget{ const AlertsScreen({super.key}); @override Widget build(BuildContext context){ return Scaffold(backgroundColor: bg, body: SafeArea(child: Column(children:[ Container(color: navy, padding: const EdgeInsets.all(16), child: Row(children:[const Icon(Icons.notifications, color: gold2), const SizedBox(width:8), const Expanded(child: Text('Mill Alerts & Notices', style: TextStyle(color: gold2, fontWeight: FontWeight.w800, fontSize:17))), TextButton(onPressed:(){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All Marked Read'))); }, child: const Text('Mark all read', style: TextStyle(color: gold2)))])), Expanded(child: ListView.builder(padding: const EdgeInsets.all(14), itemCount: Store.alerts.length, itemBuilder:(_,i){ final a=Store.alerts[i]; return cardBox(Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Row(children:[Expanded(child: Text(a['title'], style: const TextStyle(fontWeight: FontWeight.w900))), Text(a['time'], style: const TextStyle(color: Colors.grey, fontSize:12))]), Text(a['desc'], style: const TextStyle(color: Colors.grey))])); })) ]))); } }
class ProfileScreen extends StatefulWidget{ const ProfileScreen({super.key}); @override State<ProfileScreen> createState()=>_Prof(); }
class _Prof extends State<ProfileScreen>{
  late TextEditingController nameC; late TextEditingController phoneC;
  @override void initState(){ super.initState(); nameC=TextEditingController(text: Store.currentUser['name']); phoneC=TextEditingController(text:'01700-000001'); }
  @override Widget build(BuildContext context){ return Scaffold(backgroundColor: bg, body: SafeArea(child: Column(children:[ topBar(context,'Profile'), Padding(padding: const EdgeInsets.all(14), child: cardBox(Column(children:[const CircleAvatar(radius:36, backgroundColor: navy, child: Text('TI', style: TextStyle(color: gold, fontSize:22, fontWeight: FontWeight.w900))), const SizedBox(height:10), field(nameC,'Full Name'), const SizedBox(height:10), field(phoneC,'Phone', type: TextInputType.phone), const SizedBox(height:12), goldBtn('Save Profile', (){ setState(()=> Store.currentUser['name']=nameC.text); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile Saved'))); Navigator.pop(context); }), const SizedBox(height:10), SizedBox(width:double.infinity, height:48, child: OutlinedButton(onPressed:(){ Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(_)=>const LoginScreen()), (_)=>false); }, child: const Text('Logout', style: TextStyle(color: Colors.red))))])) ]))); }
}
