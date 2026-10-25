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

	vector<string> alumnos2(n);			 // alumnos sin NL ---soporte para map
	vector<pair<string, ll>> alumnos(n); // alumnos con NL por nombre prioridad
	vector<pair<ll,string>> alumnos3;			 // alumnos con NL por NL prioridad

	while (opcion != 5){
		cin >> opcion;
		if (opcion == 1){
			// esto es la primera opcion -------no se han ordenado

			for (ll i = 0; i < n; i++){
				cin >> alumnos[i].first;
				cin >> alumnos[i].second;
				alumnos3.push_back({alumnos[i].second,alumnos[i].first});
			}
			// aqui termina la primera opcion
		}

		if (opcion == 2){
			// empieza la segunda opcion

			for (ll i = 0; i < n; i++) cin >> alumnos2[i];
			sort(alumnos2.begin(), alumnos2.end());
			for (ll i = 1; i <= n; i++){
				ALUMNOS[i] = alumnos2[i - 1];
				ALUMNOS2[alumnos2[i - 1]] = i;
			}
			// aqui termina la segunda opcion
		}

		if (opcion == 3) {
			// esto es la tercera opcion
			if (alumnos.size() > 0) {
				sort(alumnos.begin(), alumnos.end());
				for (auto c : alumnos) cout << "Alumno: " << c.first << " N.L: " << c.second << '\n'; // imprime alumnos con NL asignado
			}
			else for (auto c : ALUMNOS2) cout << "Alumno: " << c.first << " N:L: " << c.second << '\n'; // imprime alumnos sin NL asignado
			// aqui termina la tercera opcion
		}

		if (opcion == 4){
			// esto es la cuarta opcion
			if (alumnos3.size() > 0){
				sort(alumnos3.begin(), alumnos3.end());
				for (auto c: alumnos3) cout << "NL: " << c.first << " Alumno: " << c.second << '\n';
			}
			else for (ll i = 1; i <= n; i++) cout << "NL: " << i << " Alumno: " << ALUMNOS[i] << '\n';
			// aqui termina la cuarta opcion
		}
	}
}
