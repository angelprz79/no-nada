#include <iostream>
#include <map>
#include <set>
#include <vector>
#include <algorithm>
using namespace std;
using ll = long long;

map<ll, string> ALUMNOS;  // alumnos sin NL asignado ordenados por NL
map<string, ll> ALUMNOS2; // alumnos sin NL asignado ordenados por nombre
int main()
{
	ll n;
	ll opcion = 1; // numero de alumnos
	cin >> n;

	vector<string> alumnos2; // alumnos sin NL ---soporte para map
	vector<pair<string, ll>> alumnos; // alumnos con NL por nombre prioridad
	vector<pair<ll,string>> alumnos3; // alumnos con NL por NL prioridad

	while (opcion != 5){
		if (!(cin >> opcion)) break;
		if (opcion == 1){
			// esto es la primera opcion -------no se han ordenado
			alumnos.clear(); // vacia los vectores para que no haya  problema de sobreescritura
			alumnos3.clear(); // hace lo mismo que arriba
			for (ll i = 0; i < n; i++){
				string aux;
				ll aux2;
				cin >> aux >> aux2;
				alumnos.push_back({aux, aux2});
				alumnos3.push_back({aux2, aux});
			}
			// aqui termina la primera opcion
		}

		if (opcion == 2){
			// empieza la segunda opcion
			alumnos.clear();
			alumnos3.clear();
			alumnos2.clear();// vacia el vector para evitar problemas de sobreescritura
			ALUMNOS.clear(); // se vacia el map para evitar lo de arriba
			ALUMNOS2.clear(); // lo mismo de arriba
			for (ll i = 0; i < n; i++){
				string aux3;
				cin >> aux3;
				alumnos2.push_back(aux3);
			}
			sort(alumnos2.begin(), alumnos2.end());
			ll i = 1;
			for (auto c: alumnos2){
				ALUMNOS[i] = c;
				ALUMNOS2[c] = i;
				i++;
			}
			// aqui termina la segunda opcion
		}

		if (opcion == 3) {
			// esto es la tercera opcion
			if (!alumnos.empty()) {
				sort(alumnos.begin(), alumnos.end());
				for (auto c : alumnos) cout << "\nAlumno: " << c.first << " N.L: " << c.second; // imprime alumnos con NL asignado
			}
			else for (auto c : ALUMNOS2) cout << "\nAlumno: " << c.first << " N:L: " << c.second ; // imprime alumnos sin NL asignado
			// aqui termina la tercera opcion
		}

		if (opcion == 4){
			// esto es la cuarta opcion
			if (!alumnos3.empty()){
				sort(alumnos3.begin(), alumnos3.end());
				for (auto c: alumnos3) cout << "\nNL: " << c.first << " Alumno: " << c.second;
			}
			else for (ll i = 1; i <= n; i++) cout << "\nNL: " << i << " Alumno: " << ALUMNOS[i];
			// aqui termina la cuarta opcion
		}
	}
}
