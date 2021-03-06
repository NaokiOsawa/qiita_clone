<template>
  <v-container v-model="article" class="item elevation-3 article-container">
    <v-layout xs-12 class="top-info-container">
      <span class="user-name">@{{ article.user.name }}</span>
      <time-ago :refresh="60" :datetime="article.updated_at" locale="en" tooltip="top" long></time-ago>
      <v-spacer></v-spacer>
      <v-btn
        fab
        flat
        dark
        small
        color="#55c500"
        @click="moveToEditArticlePage(article.id)"
        v-if="editable"
      >
        <v-icon dark>edit</v-icon>
      </v-btn>
      <v-btn fab flat dark small color="#55c500" @click="confirmDeleteArticle">
        <v-icon dark>fas fa-trash-alt</v-icon>
      </v-btn>
    </v-layout>
    <v-layout>
      <h1 class="article-title">{{ article.title }}</h1>
    </v-layout>
    <v-layout class="article-body-container">
      <div class="article-body" v-html="compiledMarkdown(article.body)"></div>
    </v-layout>
  </v-container>
</template>

<script lang="ts">
import axios from "axios";
import { Vue, Component } from "vue-property-decorator";
import TimeAgo from "vue2-timeago";
import marked from "marked";
import hljs from "highlight.js";
import Router from "../router/router";

const headers = {
  headers: {
    Authorization: "Bearer",
    "Access-Control-Allow-Origin": "*",
    "access-token": localStorage.getItem("access-token"),
    client: localStorage.getItem("client"),
    uid: localStorage.getItem("uid")
  }
};

@Component({
  components: {
    TimeAgo
  }
})
export default class ArticleContainer extends Vue {
  article: any = "";

  async mounted(): Promise<void> {
    await this.fetchArticle(this.$route.params.id);
  }

  async created(): Promise<void> {
    const renderer = new marked.Renderer();
    let data = "";
    renderer.code = function(code, lang) {
      const _lang = lang.split(".").pop();
      try {
        data = hljs.highlight(_lang, code, true).value;
      } catch (e) {
        data = hljs.highlightAuto(code).value;
      }

      return `<pre><code class="hljs"> ${data} </code></pre>`;
    };

    marked.setOptions({
      renderer: renderer,
      tables: true,
      sanitize: true,
      langPrefix: ""
    });
  }

  get compiledMarkdown() {
    return function(text: string) {
      return marked(text);
    };
  }

  get editable(): boolean {
    return localStorage.getItem("uid") === this.article.user.email;
  }

  async fetchArticle(id: string): Promise<void> {
    await axios
      .get(`/api/v1/articles/${id}`)
      .then(response => {
        this.article = response.data;
      })
      .catch(e => {
        // TODO: 適切な Error 表示
        alert(e.response.statusText);
      });
  }

  moveToEditArticlePage(id: string): void {
    Router.push(`/articles/${id}/edit`);
  }

  async confirmDeleteArticle(): Promise<void> {
    const result = confirm("この記事を削除してもよろしいですか？");

    if (result) {
      await axios
        .delete(`/api/v1/articles/${this.article.id}`, headers)
        .then(_response => {
          Router.push("/");
        })
        .catch(e => {
          // TODO: 適切な Error 表示
          alert(e.response.statusText);
        });
    }
  }
}
</script>

<style lang="scss" scoped>
.top-info-container {
  margin-bottom: 1em;
}
.article-container {
  margin-top: 2em;
}
.article-title {
  font-size: 2.5em;
  line-height: 1.4;
}
.article-body-container {
  margin: 2em 0;
  font-size: 16px;
}
.article-body {
  width: 100%;
}
.user-name {
  margin-right: 1em;
}
</style>