//Mellau Mark-Mate , 523/1
//mmim2055
//Labor 1 





//KIKOTESE://
//-a program olyan grafok eseten mukodik jol , ami: egyszeru , iranyitatlan , és nincs 0 hosszusagu ele , ez kulonosen fontos a matrixos 
//reprezentaciok miatt 
//-emiatt nem beszelhetunk hurok- es tobbszoros elekrol 
//!!!! MEGJEGYZES: a csomopontokat 0-tol szamozzuk !!!!!!


// n - csucsok szama
// m - elek szama


#include <iostream>
#include <fstream> 
#include <vector>

using namespace std;

const char* input = "graf.in";

class edge {
private:
	int from;
	int to;
	int value;

public:
	edge(int from, int to, int value) {
		this->from = from;
		this->to = to;
		this->value = value;
	}
	void print() {
		cout << from << " " << to << " " << value << endl;
	}
};

/*############  1  ############*/

void read_adj_matrix(int& n, int& m, int**& adj_matrix) {
	ifstream f(input);
	f >> n;
	f >> m;
	adj_matrix = new int* [n];
	for (int i = 0; i < n; i++) {
		adj_matrix[i] = new int[n] {0};
	}

	int u, v, s;
	for (int i = 0; i < m; i++) {
		f >> u >> v >> s;
		adj_matrix[u][v] = s;
		adj_matrix[v][u] = s;
	}
}

/*############  2  ############*/

void adj_matrix_to_inc_matrix(int n, int m, int** adj_matrix, int**& inc_matrix) {
	inc_matrix = new int* [n];
	for (int i = 0; i < n; i++) {
		inc_matrix[i] = new int[m] {0};
	}

	int curr = 0;
	for (int i = 0; i < n; i++) {
		for (int j = i; j < n; j++)
			if (adj_matrix[i][j] != 0) {
				inc_matrix[i][curr] = adj_matrix[i][j];
				inc_matrix[j][curr] = adj_matrix[i][j];
				curr++;
			}
	}
}

void inc_matrix_to_adj_list(int n, int m, int** inc_matrix, vector<vector<pair<int, int>>>& adj_list) {
	adj_list.resize(n);
	int node1 = 0, node2 = 0, value = 0;
	for (int j = 0; j < m; j++) {
		node1 = -1;
		node2 = -1;
		value = 0;
		for (int i = 0; i < n; i++) {
			if (inc_matrix[i][j] != 0) {
				if (node1 == -1) {
					node1 = i;
					value = inc_matrix[i][j];
				}
				else {
					node2 = i;
					adj_list[node1].push_back(make_pair(node2, value));
					adj_list[node2].push_back(make_pair(node1, value));
				}
			}
		}
	}

}

void adj_list_to_edge_list(int n, int m, vector<vector<pair<int, int>>> adj_list, vector<edge>& edge_list) {
	for (int i = 0; i < n; i++) {
		for (int j = 0; j < adj_list[i].size(); j++) {
			if (i < adj_list[i][j].first) {
				edge_list.push_back(edge(i, adj_list[i][j].first, adj_list[i][j].second));
			}
		}
	}
	/*for (int i = 0; i < m; i++) {
		edge_list[i].print();
	}*/
}

void print_adj_matrix(int n, int** adj_matrix) {
	for (int i = 0; i < n; i++) {
		for (int j = 0; j < n; j++) {
			cout << adj_matrix[i][j] << " ";
		}
		cout << endl;
	}
}

void print_inc_matrix(int n, int m, int** inc_matrix) {
	for (int i = 0; i < n; i++) {
		cout << i << ": ";
		for (int j = 0; j < m; j++)
			cout << inc_matrix[i][j] << " ";
		cout << endl;
	}

}

void print_adj_list(int n, vector < vector<pair<int, int>>> adj_list)
{
	for (int i = 0; i < n; i++) {
		cout << i << ": ";
		for (int j = 0; j < adj_list[i].size(); j++) {
			cout << "[" << adj_list[i][j].first << " , " << adj_list[i][j].second << "]" << " ";
		}
		cout << endl;

	}
}

void print_edge_list(int m, vector<edge> edge_list) {
	for (int i = 0; i < m; i++) {
		cout << i + 1 << ": ";
		edge_list[i].print();
	}
}

/*############  3  ############*/

void isolated_points(int n, int** adj_matrix, vector<int>& list_of_ip) {
	bool if_ip = true;
	for (int i = 0; i < n; i++) {
		int j = 0;
		if_ip = 1;
		while (j < n && if_ip) {
			if (adj_matrix[i][j] != 0) {
				if_ip = false;
			}
			j++;
		}
		if (if_ip)
			list_of_ip.push_back(i);
	}
}

void print_list_of_ip(vector<int>& list_of_ip) {
	int size = list_of_ip.size();
	if (size == 0) cout << "Nr of isolated point eq 0 !";
	for (int i = 0; i < size; i++) {
		cout << list_of_ip[i] << " ";
	}
	cout << endl;
}

/*############  4  ############*/

void end_points(int n, int m, int** inc_matrix, vector<int>& list_of_ep) {

	for (int i = 0; i < n; i++) {
		int nr_of_edges = 0;
		for (int j = 0; j < m; j++) {
			if (inc_matrix[i][j] != 0)
				nr_of_edges++;
		}
		if (nr_of_edges == 1)
			list_of_ep.push_back(i);
	}
}

void print_list_of_ep(vector<int> list_of_ep) {
	int size = list_of_ep.size();
	if (size == 0) cout << "Nr of end point eq 0 !";
	for (int i = 0; i < size; i++) {
		cout << list_of_ep[i] << " ";
	}
	cout << endl;
}

/*############  5  ############*/

bool is_regular(int n, int** adj_matrix) {
	bool regular = true;
	int fist_degree = 0;
	for (int j = 0; j < n; j++) {
		if (adj_matrix[0][j] != 0)
			fist_degree++;
	}

	for (int i = 1; i < n && regular; i++) {
		int curr_degree = 0;
		for (int j = 0; j < n && regular == 1; j++) {
			if (adj_matrix[i][j] != 0) curr_degree++;
		}
		if (curr_degree != fist_degree)
			regular = false;
	}

	return regular;
}

int main()
{
	int** adj_matrix = NULL;
	int** inc_matrix = NULL;
	vector<vector<pair<int, int>>> adj_list;
	vector<edge> edge_list;
	vector<int> list_of_ip;
	vector<int> list_of_ep;
	int n, m;
	read_adj_matrix(n, m, adj_matrix);

	cout << "Nr_nodes = " << n << endl << "Nr_edges = " << m << endl << endl;
	cout << "Adjacency matrix:\n";
	print_adj_matrix(n, adj_matrix);
	cout << endl;

	cout << "Incidency matrix:\n";
	adj_matrix_to_inc_matrix(n, m, adj_matrix, inc_matrix);
	print_inc_matrix(n, m, inc_matrix);
	cout << endl;

	cout << "Adjacency list:\n";
	inc_matrix_to_adj_list(n, m, inc_matrix, adj_list);
	print_adj_list(n, adj_list);
	cout << endl;

	cout << "Edge list:\n";
	adj_list_to_edge_list(n, m, adj_list, edge_list);
	print_edge_list(m, edge_list);
	cout << endl;

	cout << "List of isolated points:\n";
	isolated_points(n, adj_matrix, list_of_ip);
	print_list_of_ip(list_of_ip);
	cout << endl;

	cout << "List of end points:\n";
	end_points(n, m, inc_matrix, list_of_ep);
	print_list_of_ep(list_of_ep);
	cout << endl;

	if (is_regular(n, adj_matrix) == 1)
		cout << "G matrix is regular .\n";
	else
		cout << "G matrix is not regular . \n";


	delete[] adj_matrix;
	delete[] inc_matrix;
}

