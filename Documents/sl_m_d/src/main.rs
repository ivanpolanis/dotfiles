fn main() {
    let input = "Hola  ".to_lowercase();

    let result = to_number(&input);

    for r in result {
        println!("{:?}", r);
    }
}

fn to_number(input: &str) -> Vec<Vec<f64>> {
    let arr: Vec<char> = "0abcdefghijklmnñopqrstuvwxyz .,".chars().collect();

    let mut result = Vec::new();

    let pwd: [[f64; 3]; 3] = [[1.0, 0.0, 5.0], [0.0, 2.0, 0.0], [4.0, 0.0, 3.0]];

    for group in input.chars().collect::<Vec<char>>().chunks(3) {
        let col = group
            .iter()
            .map(|&c| arr.iter().position(|&x| x == c).unwrap() as f64)
            .collect::<Vec<f64>>();
        let response = matrix_prod(&col, &pwd);
        result.push(response);
    }

    result
}

fn matrix_prod(arr: &Vec<f64>, pwd: &[[f64; 3]; 3]) -> Vec<f64> {
    let mut res = vec![0.0; 3];

    for i in 0..3 {
        for j in 0..3 {
            res[i] += arr[j] * pwd[j][i];
        }
        res[i] = res[i].round();
    }

    res
}
