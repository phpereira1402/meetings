var event = new Vue({
    el: element,
    data: {
      user: 'teste', 
      teste: 'teste 2'
    },
    methods: {
      saveUser() {
        this.$http.post('/users', { user: this.user }).then(response => {
          Turbolinks.visit(`/users/${response.body.id}`)
        }, response => {
          console.log(response)
        })
      }
    }
  });