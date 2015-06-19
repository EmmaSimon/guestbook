#!/usr/bin/env perl
use Mojolicious::Lite;
use DBI;

app->config(hypnotoad => {proxy => 1});

my $driver = "Pg";
my $database = "guestbook";
my $dsn = "DBI:$driver:dbname=$database;host=127.0.0.1;port=5432";
my $user = "USERNAME";
my $password = "PASSWORD";

# Route to index
get '/' => sub {
	my $c = shift;

	# Connect to PSQL database and store the result of the select statement in an array
	my $dbh = DBI->connect($dsn, $user, $password, {RaiseError => 1, AutoCommit => 0})
		or die $DBI::errstr;
	my $entries = $dbh->selectall_arrayref("SELECT * FROM book ORDER BY ts DESC");
	$dbh->disconnect;

	# Stash the array for use in the HMTL template, then render the HTML
	$c->stash(entries => $entries);
	$c->render(template => 'index');
} => 'index';

# Route to the new entry form page
get '/new-entry' => sub {
	my $c = shift;

	# Render the HTML
	$c->render(template => 'new-entry');
} => 'new-entry';

# Route to submit, for storing form inputs in the database
post '/submit' => sub {
	my $c = shift;

	# Get form data from controller parameters, along with the remote address from the transaction data
	my $name = $c->param('name');
	my $email = $c->param('email');
	my $comment = $c->param('comment');
	my $addr = $c->tx->remote_address;

	# Connect to the database and insert the values from the form, along with a human readable timestamp, and a PSQL timestamp for ordering
	my $dbh = DBI->connect($dsn, $user, $password, {RaiseError => 1, AutoCommit => 0})
		or die $DBI::errstr;
	my $sth = $dbh->prepare("INSERT INTO book VALUES (?, ?, ?, to_char(now(), 'HH12:MI AM TZ, Mon DD, YYYY'), ?, now())");
	$sth->execute($name, $email, $comment, $addr);
	$dbh->commit;
	$dbh->disconnect;

	# Instead of rendering a seperate submit page, redirect to index
	$c = $c->redirect_to('index');
} => 'submit';

app->start;

__DATA__

@@ index.html.ep
% layout 'default';
% title 'Guestbook';
<a href= 'new-entry' class='button'>Add to the guestbook</a>
<p><table>
  	<tr>
  		<th>Name</th>
  		<th>Email Address</th>
  		<th>Comment</th>
  		<th>Time</th>
  		<th>IP Address</th>
  	</tr>
    % foreach my $entry ( @{$entries} ) {
    <tr>
       <td><%= $entry->[0] %></td>
       <td><%= $entry->[1] %></td>
       <td><%= $entry->[2] %></td>
       <td><%= $entry->[3] %></td>
       <td><%= $entry->[4] %></td>
    </tr>
    % }
</table></p>

@@ new-entry.html.ep
% layout 'default';
% title 'New Entry';
<a href= '/' class='button'>View the guestbook</a>
<script src="js/validate.js" type="text/javascript"></script>
<p><form id="entry" onsubmit="return validate_form(event);" action="submit" method="post">
	<input type="text" name="name" placeholder="Name"><br>
	<input type="text" name="email" placeholder="Email Address"><br>
	<input type="text" name="comment" id ="comment" placeholder="Comment"><br>
	<%= submit_button 'Submit' %>
</form></p>

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head>
  	<title><%= title %></title>
  	<link rel="icon" href="favicon.png">
  	<meta name="description" content="A simple guestbook app.">
  	<meta name="author" content="Emma Simon">
  	<%= stylesheet 'css/guestbook.css' %>
  </head>
  <body><%= content %></body>
</html>