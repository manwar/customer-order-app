package CustomerOrderApp;

use strict;
use warnings;
use Try::Tiny;
use Email::Valid;
use JSON;
use Dancer2;
use Dancer2::FileUtils qw(path);

=head1 NAME

CustomerOrderApp - sample web app

=head1 VERSION

Version 0.01

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=cut

$manwar::VERSION   = '0.01';
$manwar::AUTHORITY = 'cpan:MANWAR';

# TODO: the default home page presents user to log in
get '/' => sub {
    template 'login';
};

# the login page has two text fields and a submit button.
# username and password are the name of two fields.
# form action is POST to /login.
post '/login' => sub {
    my $username = body_parameters->{'username'};
    my $password = body_parameters->{'password'};

    # validate user
    if (validate_user($username, $password)) {
        # TODO: save user in session

        # TODO: form-selection template would present menu
        # a) template amendment form
        # b) tech support form
        return template 'form-selection';
    }
    else {
        return template 'login' => {
            error => "Invalid username/password.",
        };
    }
};

# TODO: the form would have the following objects
# 1) Dropdown to select the client
# 2) Dropdown to select the template
# 3) Upload file field
# 4) Text field describing the change
# 5) Submit button
get '/template-amendment-form' => sub {
    template 'template-amendent-form' => {
        clients   => get_client_list(),
        templates => get_template_list(),
    };
};

post '/template-amendment-form' => sub {
    my $client      = body_parameters->{'client'};
    my $template    = body_parameters->{'template'};
    my $description = body_parameters->{'description'};
    my $upload_file = upload->{'file'};

    # fetch the location of uploads folder
    my $dir = path(config->{appdir}, 'uploads');
    mkdir $dir if not -e $dir;

    my $path = path($dir, $upload_file->basename);
    if (-e $path) {
        return "'$path' already exists";
    }

    $upload_file->link_to($path);

    # TODO: save the request in the database
    save_template_amendment_request(
        $client, $template, $description, $path);

    my $body = sprintf("Client: %s\n", $client);
    $body .= sprintf("Template: %s\n", $template);
    $body .= sprintf("Description: %s\n", $description);

    my $data = {
        "to"          => 'foo@bar.com',
        "from"        => 'foo@bar.com',
        "subject"     => 'something',
        "body"        => $body,
        "attachments" => [
            {
                "mime-type" => "text/plain",
                "file" => $path,
            }
        ]
    };

    save_email_job($data);

    return "Saved template amendment form";
};

# TODO: the form would have the following objects
# 1) Dropdown to select the client
# 2) Text field describing the change
# 3) Text field to accept the user email address
# 4) Submit button
get '/tech-support-form' => sub {
    template 'tech-support-form' => {
        clients => get_client_list(),
    };
};

post '/tech-support-form' => sub {
    my $client      = body_parameters->{'client'};
    my $email       = body_parameters->{'email'};
    my $description = body_parameters->{'description'};

    my $valid_email;
    try {
        $valid_email = Email::Valid->address($email);
    }
    catch {
        error 'Problems with Email::Valid!: ' . $_;
    };

    # TODO: save the request in the database
    save_tech_support_request($client, $valid_email, $description);

    my $body = sprintf("Client: %s\n", $client);
    $body .= sprintf("Email: %s\n", $valid_email);
    $body .= sprintf("Description: %s\n", $description);

    my $data = {
        "to"      => 'foo@bar.com',
        "from"    => 'foo@bar.com',
        "subject" => 'something',
        "body"    => $body,
    };

    save_email_job($data);
};

#
#
# SUBROUTINES

sub validate_user {
    my ($username, $password) = @_;

    # TODO: validate user against the database record.
    return 1;
}

sub save_template_amendment_request {
    my ($client, $template, $description, $path) = @_;

    # TODO: save the data in the database.
}

sub save_tech_support_request {
    my ($client, $email, $description) = @_;

    # TODO: save the data in the database.
}

sub get_client_list {
    # TODO: fetch client list from the database.
}

sub get_template_list {
    # TODO: fetch template list from the database.
}

sub save_email_job {
    my ($data) = @_;

    my $dir = path(config->{appdir}, 'email_jobs');
    mkdir $dir if not -e $dir;

    my $timestamp = localtime(time);
    my $file = sprintf("%s.json", $timestamp);
    my $path = path($dir, $file);

    open  my $FILE, ">$path";
    print $FILE JSON->new->utf8(1)->pretty(1)->encode($data);
    close $FILE;
}

1;
