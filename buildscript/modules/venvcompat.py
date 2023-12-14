def search_and_replace(file_path, search_word, replace_word):
   with open(file_path, 'r') as file:
      file_contents = file.read()

      updated_contents = file_contents.replace(search_word, replace_word)

   with open(file_path, 'w') as file:
      file.write(updated_contents)

file_path = 'meson.build'
search_word = '\'python3\''
replace_word = ''
search_and_replace(file_path, search_word, replace_word)