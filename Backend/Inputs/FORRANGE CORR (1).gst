var p_basicas float64 = 0.0
var p_inter float64 = 0.0
var p_func float64 = 0.0
var p_slice float64 = 0.0
var p_structs float64 = 0.0

func iniciar_sistema() string {
    return "SYS_ONLINE"
}

func calcular_presion(fuerza float64, area float64, k float64) float64 {
    var val float64 = (fuerza / area) * k
    return val
}

func acumulador_comb(n int, acc int) int {
    if n == 0 { return acc }
    if n % 2 == 0 {
        return acumulador_comb(n - 1, acc + (n * 2))
    }

    // EL DOBLE RETURN NO LO AGARRA -----------------------------------------------------
    return acumulador_comb(n - 1, acc - n)
}

func transmutar_cripto(hash_bytes []int) []int {
    var validacion int = hash_bytes[0] + hash_bytes[2] 
    if validacion == 4 { p_func = p_func + 3.0 } 

    copia := []int{} 
    for i := 0; i < len(hash_bytes); i = i + 1 {
        copia = append(copia, hash_bytes[i] * 10)
    }
    return copia 
}

// SIN ELEMENTOS DE ARREGLO DENTRO DE STRUCTS
struct Transaccion {
    string id;
    float64 monto;
    bool aprobada;
}

struct Blockchain {
    string moneda;
    Transaccion tx;
}

func main() {
    fmt.Println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
    fmt.Println("@@        EVALUADOR MAESTRO - COMPILADORES 1 PROYECTO 2     @@")
    fmt.Println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
    fmt.Println("  (Iniciando simulación transaccional con múltiples fases)  ")

    // -------------------------------------------------------------
    // FASE 1: BÁSICAS (7 PUNTOS)
    // -------------------------------------------------------------
    var test_b int = 0
    var var_it int = 100; var var_f float64 = 5.5; var var_str string = "OK"; var var_b bool = true;
    if var_it == 100 && var_f == 5.5 && var_str == "OK" && var_b { test_b = test_b + 1 }

    var_it = 50; var_f = 9.99;
    if var_it == 50 && var_f == 9.99 { test_b = test_b + 1 }

    var v_arit float64 = ((var_it * 2.0) / 4.0) + (13 % 5) 
    # //Error léxico intencional aquí
    if v_arit == 28.0 { test_b = test_b + 1 } 

    // ESTE NO JALAAAaaaaaa
    var val_nul string
    var r_rel bool = (v_arit >= 20.0) == (var_f < 10.0) != (val_nul != "") 
    if r_rel { test_b = test_b + 1 } 

    var r_log bool = !(!(r_rel && var_b) || false) 
    if r_log { test_b = test_b + 1 } 

    var n_float float64; var n_bool bool;
    if val_nul == "" && n_float == 0.0 && !n_bool { p_basicas = p_basicas + 0.5 } 

    var opt int = 1; var opt2 int = 1;
    if opt == opt2 { p_basicas = p_basicas + 0.5 } 

    if test_b == 5 { p_basicas = p_basicas + 5.0 }
    p_basicas = p_basicas + 1.0 

    // -------------------------------------------------------------
    // FASE 2: INTERMEDIAS (16 PUNTOS)
    // -------------------------------------------------------------
    var scope_base int = 1000 $
    if scope_base == 1000 {
        var scope_base int = 500
        if scope_base == 500 {
            var scope_base int = 250
            if scope_base == 250 { p_inter = p_inter + 2.0 } 
        }
    }

    var cond string = "test"
    if cond == "fail" { p_inter = p_inter + 0.0 } else if cond == "test" { p_inter = p_inter + 2.0 }

    var w_val int = 0
    for w_val < 10 { w_val = w_val + 2 } 
    if w_val == 10 { p_inter = p_inter + 2.0 } 

    var limit_it int = 0
    var c_ct bool = false; var c_bk bool = false;
    for i := 0; i < 50; i = i + 1 {
        if i == 20 { c_bk = true; break } 
        if i % 2 != 0 { c_ct = true; continue } 
        limit_it = limit_it + i
    } 
    if limit_it == 90 { p_inter = p_inter + 2.0 } 
    if c_ct { p_inter = p_inter + 2.0 } 
    if c_bk { p_inter = p_inter + 2.0 } 


	//FORRANGE CORRECTION ARZ
    letras := []string{"B", "u", "c", "l", "e"}
    var sum_caracter int = 0

    for indice, car := range letras {
        sum_caracter = sum_caracter + 1
    }

    if sum_caracter == 5 {
        p_inter = p_inter + 2.0
    }

    switch sum_caracter {
        case 5:
            p_inter = p_inter + 2.0
        case 10:
            p_inter = p_inter + 0.0
    }

    // -------------------------------------------------------------
    // FASE 3: FUNCIONES (16 PUNTOS)
    // -------------------------------------------------------------
    if iniciar_sistema() == "SYS_ONLINE" { p_func = p_func + 1.0 } 
    if calcular_presion(100.0, 20.0, 1.5) == 7.5 { p_func = p_func + 2.0 } 
    if acumulador_comb(5, 0) == 3 { p_func = p_func + 4.0 } 

    var parse_i int = strconv.Atoi("1024")
    if parse_i == 1024 { p_func = p_func + 1.0 } 

    var parse_f float64 = strconv.ParseFloat("3.1415")
    if parse_f == 3.1415 { p_func = p_func + 1.0 } 

    // SE LE AGREGÓ EL .string AL FINAL SEGÚN SECCIÓN 7.2.4 DEL MANUAL
    var tp string = reflect.TypeOf(parse_i);
    if tp == "int" { p_func = p_func + 1.0 } 
    
    origen := []int{1, 2, 3}
    new_slice := transmutar_cripto(origen)
    if len(new_slice) == 3 && new_slice[2] == 30 { 
        p_func = p_func + 3.0 
    }

    // -------------------------------------------------------------
    // FASE 4: SLICES Y MATRICES MULTIDIMENSIONALES (32 PUNTOS)
    // -------------------------------------------------------------
    data_bytes := []int{0, 255, 128, 64}
    servers := []string{"A", "B", "C"}
    if len(data_bytes) == 4 && servers[1] == "B" {
        p_slice = p_slice + 5.0 
        p_slice = p_slice + 2.0 
    }

    var mod_v int = data_bytes[2] 
    data_bytes[3] = 99
    if mod_v == 128 && data_bytes[3] == 99 { p_slice = p_slice + 4.0 } 

    data_bytes = append(data_bytes, 777)
    if len(data_bytes) == 5 && data_bytes[4] == 777 { p_slice = p_slice + 5.0 ° } 

    var s_pos int = slices.Index(servers, "C")
    if s_pos == 2 { p_slice = p_slice + 2.0 } #####

    var domain_str string = strings.Join(servers, ".")
    if domain_str == "A.B.C" { p_slice = p_slice + 2.0 } 

    red_neuronal := [][]int{
        {1, 0, 0, 1},
        {0, 1, 1, 0},
    } 
    p_slice = p_slice + 6.0 
    
    var val_nulo int = red_neuronal[0][1] 
    red_neuronal[1][0] = 500
    if val_nulo == 0 && red_neuronal[1][0] == 500 { p_slice = p_slice + 6.0 } 

    // -------------------------------------------------------------
    // FASE 5: STRUCTS Y COMPOSICIÓN (20 PUNTOS)
    // -------------------------------------------------------------
    p_structs = p_structs + 4.0 

    Transaccion t_1 = { id: "TX-998", monto: 1540.5, aprobada: false };
    Blockchain red_blockchain = { moneda: "GoCoin", tx: t_1 };

    if red_blockchain.moneda == "GoCoin" && red_blockchain.tx.monto == 1540.5 {
        p_structs = p_structs + 4.0
    }

    red_blockchain.moneda = "SuperCoin"
    if red_blockchain.moneda == "SuperCoin" {
        p_structs = p_structs + 4.0
    }

    var r_ip string = red_blockchain.moneda
    if r_ip == "SuperCoin" {
        p_structs = p_structs + 3.0
    }

    red_blockchain.tx.aprobada = true
    if red_blockchain.tx.aprobada {
        p_structs = p_structs + 3.0
    }

    var fetch_bool bool = red_blockchain.tx.aprobada
    if fetch_bool {
        p_structs = p_structs + 2.0
    }
$$
    // ==========================================
    // FASE EXTRA: FIGURAS CON BUCLES Y CONDICIONALES (9 PTS)
    // ==========================================
    var p_figuras float64 = 0.0
    var val_rombo string = ""

        fmt.Println("")
        fmt.Println(" --- [DIBUJANDO ROMBO GEOMÉTRICO] ---") $$
        var n_rombo int = 4
        for i := 1; i <= n_rombo; i = i + 1 {
            var r_str string = ""
            for j := 1; j <= n_rombo - i; j = j + 1 { r_str = r_str + " " }
            for k := 1; k <= (2*i - 1); k = k + 1 { r_str = r_str + "*" }
            fmt.Println(r_str)
        }
        for i := n_rombo - 1; i >= 1; i = i - 1 {
            var r_str string = ""
            for j := 1; j <= n_rombo - i; j = j + 1 { r_str = r_str + " " }
            for k := 1; k <= (2*i - 1); k = k + 1 { r_str = r_str + "*" }
            if i == 1 { val_rombo = r_str }
            fmt.Println(r_str)
        }
        if val_rombo == "   *" { p_figuras = p_figuras + 4.5 }

        var val_cuadro string = ""
        fmt.Println("")
        fmt.Println(" --- [DIBUJANDO CUADRADO HUECO] ---") °°°°°
        var lado int = 6
        for i := 0; i < lado; i = i + 1 {
            var str_sq string = ""
            for j := 0; j < lado; j = j + 1 {
                if i == 0 || i == lado - 1 || j == 0 || j == lado - 1 {
                    str_sq = str_sq + "* "
                } else {
                    str_sq = str_sq + "  "
                }
            }
            if i == lado - 1 { val_cuadro = str_sq }
            fmt.Println(str_sq)
        }
        if val_cuadro == "* * * * * * " { p_figuras = p_figuras + 4.5 }

        // ==========================================
        // CÁLCULO DE REPORTES Y CONSOLA DE SALIDA
        // ==========================================
        var pts_totales float64 = p_basicas + p_inter + p_func + p_slice + p_structs + p_figuras

        fmt.Println("")
        fmt.Println("> [VERIFICACIÓN INTERNA FINALIZADA EXOSFERICAMENTE]")
        fmt.Println("")
        fmt.Println("             -- DESGLOSE DE EVALUACIÓN --             ")
        fmt.Println("  [1] Funcionalidades Básicas:      ", p_basicas, " / 7.0")
        fmt.Println("  [2] Funcionalidades Intermedias:  ", p_inter, " / 16.0")
        fmt.Println("  [3] Funciones Estructurales:      ", p_func, " / 16.0")
        fmt.Println("  [4] Slices y Arreglos Multiples:  ", p_slice, " / 32.0")
        fmt.Println("  [5] Structs con Anidación Mútiple:", p_structs, " / 20.0")
        fmt.Println("  [6] Figuras ASCII (For/If):       ", p_figuras, " / 9.0")
        fmt.Println("--------------------------------------------------------------")
        fmt.Println("           PUNTUACIÓN TOTAL DEL ALUMNO APLICADA:              ")
        fmt.Println("                    --> ", pts_totales, " / 100.0 <--           ")
        fmt.Println("--------------------------------------------------------------")
        
        if pts_totales == 100.0 {
            fmt.Println("[RESULTADO DEL INTÉRPRETE]: APROBACIÓN MASTER CUM LAUDE")
        } else {
            fmt.Println("[RESULTADO DEL INTÉRPRETE]: REVISIÓN ESTRICTA REQUERIDA")
        }
}

main();