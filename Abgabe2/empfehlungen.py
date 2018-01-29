'''

@author: Niklas Goertz
@author: Michael Heide
@author: Henock Arega


Einzugebende Argumente: Die NutzerID eines registrierten Nutzers.

'''

import sys, psycopg2, random
from sys import argv

host = 'db'
port = '5432'
database = '__database__'
user = '__usename__'
password = '__password__'


try:
    cnx = psycopg2.connect(user=user, password=password, database=database, host=host, port=port)
    
    user = cnx.cursor()
    user.execute('SELECT * FROM regBenutzer rb WHERE rb.nutzerID = \'{}\';'.format(argv[1]))
    
    reservierungen = cnx.cursor();
    reservierungen.execute('SELECT vorstellungID FROM reservierung r WHERE r.nutzerID = \'{}\';'.format(argv[1]))
    
    seenMovies = {}
    genreCount = {}
    for reservierung in reservierungen:
        movie = cnx.cursor()
        movie.execute("SELECT f.titel, f.genre FROM film f, (SELECT * FROM vorstellung v WHERE v.vorstellungID = \'{}\') AS vID WHERE vID.titel = f.titel;".format(''.join(reservierung)))
        movie = [list(m) for m in movie][0]
        
        genre = ''.join(movie[1])
        if genre in seenMovies:
            print(type(seenMovies.get(genre)))
            seenMovies[genre] = seenMovies.get(genre) + [movie[0]]
        else:
            seenMovies[genre] = [movie[0]]
        
    #genreCount = [f:len(seenMovies.get(f)) for f in seenMovies]
    genreCount = dict(map(lambda x: (x, len(seenMovies.get(x))), seenMovies))
    print(seenMovies)
    print(genreCount)
    
    allMovies = cnx.cursor();
    allMovies.execute('SELECT * FROM film;'.format(argv[1]))
    allMovies = [list(m) for m in allMovies][0]
    
    genreCount = sorted(genreCount, key = genreCount.get)
    print(genreCount)
    
    for m in seenMovies.get(genreCount[-1]):
        if m not in allMovies:
            print("Wir empfehlen:", m)
            break
    else:
        randomMovie = random.randint(1, len(allMovies) - 1)
        print("Wir empfehlen:", allMovies[randomMovie])
    
except psycopg2.Error as msg:
    print("VERBINDUNGSFEHLER: ", msg)
    sys.exit()
