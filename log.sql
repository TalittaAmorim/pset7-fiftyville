-- Mantenha um registro de qualquer consulta SQL que você executar enquanto resolve o mistério.

--- A informaçao dada foi quee o roubo aconteceu no dia 28/07/2022 na rua  Chamberlin Street.
SELECT description FROM crime_scene_reports
WHERE day = 28 AND month = 7 AND year = 2020 AND street = "Chamberlin Street";
         --A descriçao do incidente foi a seguinte:
         
 /* O roubo do pato CS50 ocorreu às 10h15 no tribunal da Chamberlin Street. 
  As entrevistas foram realizadas hoje com três testemunhas que estavam presentes 
  na ocasião - cada uma de suas transcrições de entrevista menciona o tribunal.*/
 
         -- transcriçao das testemunhas 
SELECT transcript FROM interviews WHERE day = 28 AND month = 7 AND year = 2020 
AND transcript LIKE "%courthouse%";

   ---T1:
   /*"Em dez minutos após o roubo, eu vi o ladrão entrar em um carro no estacionamento
   do tribunal e dirigir para longe. Se você tiver imagens de segurança do estacionamento do tribunal,
   talvez queira procurar por carros que saíram do estacionamento nesse período de tempo"*/
   
   ---T2:
   /*Eu não sei o nome do ladrão, mas foi alguém que eu reconheci. 
   No início desta manhã, antes de chegar ao tribunal, eu estava 
   andando pelo caixa eletrônico da Rua Fifer e vi o ladrão lá sacando algum dinheiro.*/
   
   --T3:
  /* " Quando o ladrão estava saindo do tribunal, eles chamaram alguém que 
  falou com eles por menos de um minuto. Na ligação, eu ouvi o ladrão dizer que eles estavam planejando pegar 
  o primeiro vôo da Fiftyville amanhã. O ladrão então pediu à pessoa da outra ponta 
  do telefone para comprar o bilhete de avião."*/
  
--- Verificaçao de quem estava no tribunal e estava na área de saída
SELECT name FROM people JOIN courthouse_security_logs ON people.license_plate
= courthouse_security_logs.license_plate 
WHERE day = 28 AND month = 7 
AND year = 2020 AND hour = 10 AND minute >= "15" AND minute < "25" AND minute < "25" AND activity = "exit";

    --- A saída foi os nomes dessas pessoas, que agora sao consideradas suspeitas:
    /*      Patrick
           ! Ernest
            Amber
            Danielle
            Roger
           ! Elizabeth
        !    Russell
            Evelyn
*/

   --Acesso ao historico do nomes das pessoas que fizeram transaçoes de saque na rua fiffer Street 

SELECT DISTINCT name FROM people 
JOIN bank_accounts ON people.id = bank_accounts.person_id 
JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number
WHERE day = 28 AND month =7 AND year = 2020 AND transaction_type = "withdraw" AND 
atm_location = "Fifer Street";

    ---- esses foram os nomes:( * Há nomes que se repetem)
   /*       Danielle
            Bobby
            Madison 
            Ernest  🆘 
            Roy
            Elizabeth 🆘 
            Victoria
            Russell 🆘 
*/

--- trabalhando com a seguinte informação: 
    /* " Quando o ladrão estava saindo do tribunal, eles chamaram alguém que 
  falou com eles por menos de um minuto. Na ligação, eu ouvi o ladrão dizer que eles estavam planejando pegar 
  o primeiro vôo da Fiftyville amanhã. O ladrão então pediu à pessoa da outra ponta 
  do telefone para comprar o bilhete de avião."*/
  -- checar a compra de passagem de avião avião do dia 29/07/2020
  SELECT name FROM people JOIN passengers ON people.passport_number = passengers.passport_number 
  WHERE flight_id = (SELECT id FROM flights WHERE day = 29 AND month = 7 AND year = 2020
  ORDER BY hour, minute LIMIT 1);
  
  -- Obtemos os seguintes suspeitos: Doris, Roger , Ernest 🆘, Edward, Evenlyn, Madison 🆘, Bobby 🆘, Danielle 🆘 
  -- suspeitos principais: Ernet e Danielle 
  
   -- VERIFICANDO as pessoas que realizaram ligações de menos de 1 minuto no dia do roubo 
SELECT DISTINCT name FROM people JOIN phone_calls
ON people.phone_number = phone_calls.caller
WHERE day = 28 AND month = 7 AND year = 2020 AND duration < 60;
 -- nomes suspeitos que saíram: Roger, Evenly, Ernest, Madison, Russel, Kimberly, Bobby, Victoria
 
 --- pela repetiçao nos acontecimentos, podemos concluir que ERNEST é o LADRÃO.
 
--- saber para qual cidade o fugitivo quer fugir 
SELECT city FROM airports WHERE id = ( SELECT destination_airport_id
FROM flights WHERE year = 2020 AND month = 7 AND day = 29 
ORDER BY hour,minute LIMIT 1); 

-- descobrir o cúmplice, verificando quem foi a pessoa que o ladrão ligouu 
 
SELECT name FROM people JOIN  phone_calls ON people.phone_number = phone_calls.receiver 
WHERE day = 28 AND month =7 AND year = 2020 AND duration < 60 AND caller = ( 
SELECT phone_number FROM people WHERE name = "Ernest");

--- nome do cumplice : Berthold
