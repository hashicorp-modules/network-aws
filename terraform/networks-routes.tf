#
# Public
#
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags {
    Name = "${var.environment_name}-public"
  }
}

resource "aws_route_table_association" "public" {
  count = "${length(var.vpc_cidrs_public)}"

  subnet_id      = "${element(aws_subnet.public.*.id,count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

#
# Private
#
resource "aws_route_table" "private_subnet" {
  count = "${length(var.vpc_cidrs_private)}"

  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.nat.*.id,count.index)}"
  }

  tags {
    Name = "${var.environment_name}-private-subnet-${count.index}"
  }
}

resource "aws_route_table_association" "private" {
  count = "${length(var.vpc_cidrs_private)}"

  subnet_id      = "${element(aws_subnet.private.*.id,count.index)}"
  route_table_id = "${element(aws_route_table.private_subnet.*.id,count.index)}"
}
