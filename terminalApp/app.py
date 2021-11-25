import os

if __name__ == '__main__':
    ips = {'1': 'http://34.138.10.197:50070', '2': 'http://34.138.10.197:8080', '3': "http://34.138.10.197:8888", '4': 'http://34.138.10.197:9000'}
    s = 'Welcome to Big Data Processing Application\n' + \
        'Please type the number that corresponds to which application you woule like to run:\n' + \
        '1. Apache Hadoop\n2. Apache Spark\n3. Jupyter Notebook\n4. SonarQube and SonarScanner\n\n' + \
        'Please type the number and hit "Return" to see the IP address. Enter "q" to quit app\n' + \
        'Type the number here >'
    option = ''
    while True:
        option = input(s)
        if option == 'q': break
        print("\nYou can visit this ip:"+ ips[option] + "\n")
