# Duolingo API

| Name            | URL                                            | Query Paremeter                                         | Body                             | Required Auth |
| --------------- | ---------------------------------------------- | ------------------------------------------------------- | -------------------------------- | ------------- |
| Version Info    | <https://www.duolingo.com/api/1/version_info>  | -                                                       | -                                | NO            |
| Login           | <https://www.duolingo.com/login>               | ?login={username or email}&password={password}          | -                                | NO            |
| Users           | <https://www.duolingo.com/2017-06-30/users>    | /{userid}                                               | -                                | YES           |
| Overview        | <https://www.duolingo.com/vocabulary/overview> | -                                                       | -                                | YES           |
| Hints           | <https://d2.duolingo.com/words/hints>          | /{learningLanguage}/{formLanguage}?sentence={$sentence} | -                                | NO            |
| Switch Language | <https://www.duolingo.com/switch_language>     | -                                                       | from_language, learning_language | YES           |
