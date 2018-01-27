import sys, psycopg2, random

host = 'db'
port = '5432'
database = '__database__'
user = '__username__'
password = '__password__'

try:
    cnx = psycopg2.connect(user=user, password=password, database=database, host=host, port=port)

    users = cnx.cursor()
    users.execute('SELECT vorname, nachname, nutzerID FROM regBenutzer;')
    users = ['{} {} ({})'.format(u[0], u[1], u[2].replace(' ', '')) for u in users]

    movies = cnx.cursor()
    movies.execute('SELECT titel FROM film;')
    movies = [movie for movie in movies]

    for u in users:
        print( 'Wir empfehlen {} folgenden Film: {}'.format( u, str(''.join(movies[random.randint(0, len(movies)-1)]) ) ) )


except psycopg2.Error as msg:
    print("VERBINDUNGSFEHLER: ", msg)
    sys.exit()
